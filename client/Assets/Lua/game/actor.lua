

local Class = {}
Class.__index = Class

function Class.create(data,is_self)
	data._type= "actor"

	data.ai = AI.create(data,is_self)
	data.used_ai = not is_self

	data.cfg = cfg_actor[data.type_id]


	local base_index = 0

	for i,v in ipairs(data.cfg.skill_loop) do
		if v  == 0 then
			base_index = i
			break
		end
	end

	data.attak_times = 1
	data.atk_times_base = base_index
	data.atk_times_loop_count = #data.cfg.skill_loop - base_index

	data.base_attrs = cfg_level[data.type_id][data.level]

	setmetatable(data,Class)


	data:init()

	return data
end

function Class:clone()
	local temp = clone_table(self)
	temp.attrs = clone_table(self.attrs)

	setmetatable(temp,Class)

	return temp
end

function Class:init()

	self.master_skill = cfg_master_skill[self.type_id]

	self.buff = {}

	self.attrs = {}
	self.attrs_add = {}
	self.attrs_xadd = {}
	self.attrs_xsub = {}

	for k,v in pairs(self.base_attrs) do
		self:comput_attr(k)
	end

	self.attrs.max_energy = self.cfg.max_energy
	self.attrs.energy = 0

	self.attrs.hp = self.attrs.max_hp

	self.attrs.speed = self.cfg.speed
	self.attrs.atk_speed = self.cfg.atk_speed

	if self.power then
		self.attrs.max_hp = self.attrs.max_hp * self.power
		self.attrs.hp = self.attrs.max_hp

		self:add_attr_xadd("p_atk",100*self.power)
		self:add_attr_xadd("m_atk",100*self.power)
	end

	--self.pos   = gameplay:get_start_pos(self.team,self.pos_index)
end


function Class:add_energy(value)
	local result = self.attrs.energy + value
	if result < 0 then
		result = 0
	elseif result > self.attrs.max_energy then
		result = self.attrs.max_energy
	end

	self.attrs.energy = result

	--print(value,self.attrs.energy,self.attrs.max_energy)

	gameplay:energy_msg(self)
end

function Class:add_attr_ex(k,value)
	local old = self.attrs[k] or 0
	self.attrs[k] = value + old
end

function Class:add_attr(k,value)
	if k == "lock_skill" then
		self:add_attr_ex(k,value)
		if self.attrs.lock_skill and self.attrs.lock_skill > 0 then
			self:stop_skill()
			gameplay:add_msg("lock_skill",{id=self.id,value=true})
		else
			gameplay:add_msg("lock_skill",{id=self.id,value=false})
		end
		return
	end

	if self.attrs_add[k] then
		self.attrs_add[k] = self.attrs_add[k] + value
	else
		self.attrs_add[k] = value
	end
	self:comput_attr(k)

	if k == "speed" then
		gameplay:add_msg("changed_speed",{id=self.id,speed=self.attrs.speed})
	end
end

function Class:add_attr_xadd(k,value)
	if self.attrs_xadd[k] then
		self.attrs_xadd[k] = self.attrs_xadd[k] + value
	else
		self.attrs_xadd[k] = value
	end
	self:comput_attr(k)
end

function Class:comput_attr(k)
	local base = self.base_attrs[k] or self.cfg[k] or 0

	local add = self.attrs_add[k] or 0

	local x_add = self.attrs_xadd[k] or 0
	local x_sub = self.attrs_xsub[k] or 0

	self.attrs[k] = ((base + add ) * (100 + x_add) / (100 + x_sub))
end

function Class:move_to(pos,speed,no_anim)
	if speed then
		self.attrs.speed = speed
	else
		self.attrs.speed = self.cfg.speed
	end

	self.des_pos = pos:Clone()
	--print(pos)

	gameplay:add_msg("move_to",{id=self.id,pos=pos,speed=self.attrs.speed,no_anim=no_anim})

	return true
end

function Class:move_to_no_anim(pos,speed)
	return self:move_to(pos,speed,true)
end

function Class:is_moving()
	return self.des_pos
end

function Class:stop_move()
	if self.des_pos then
		self.des_pos = nil
		gameplay:add_msg("stop_move",{id=self.id,pos=self.pos})
	end
end

function Class:stop_skill(is_all)
	--print(self.skill)
	if self.skill then
		if is_all or (self.skill.index~=1) then
			self.skill:stop()
			self.skill = nil
			self:play_anim("idle")
		end
	end
end

function Class:stop_master_skill()
	--print(self.skill)

	if self.skill and (self.skill.index==0) then
		self.skill:stop(true)
		self.skill = nil
		self:play_anim("idle")
	end
end


function Class:play_anim(anim,speed)
	gameplay:add_msg("play_anim",{id=self.id,anim=anim,speed=speed})
end

function Class:get_anim_long(anim)
	--TODO:need export client anim time, don't used client API
	return game_client:get_anim_time(self.id,anim)
end

function Class:pause_anim()
	gameplay:add_msg("pause_anim",{id=self.id})
end

function Class:resume_anim()
	gameplay:add_msg("resume_anim",{id=self.id})
end

function Class:attack(a)
	if a == nil then
		return false
	end

	local dis  = findFuns.dis(a,self)

	if (dis - 0.000001) > self.cfg.atk_dis then
		return false
	end

	local index = self.attak_times

	if index >= self.atk_times_base then
		index = index - self.atk_times_base
		index = index % self.atk_times_loop_count
		index = index + self.atk_times_base + 1
	end

	local id = self.cfg.skill_loop[index]

	if not self:can_used_skill() then
		id = 1
	end

	if self:used_skill(id,{objects={a}}) then
		self.attak_times = self.attak_times + 1
		return true
	end
end

function Class:can_used_skill()
	if self.skill and self.skill.index == 0 then
		return false
	end

	if self.attrs.lock_skill and (self.attrs.lock_skill > 0) then
		return false
	end
	return true
end


function Class:used_master_skill()
	if not self:can_used_skill() then
		return false
	end

	if gameplay.pause_obj then
		return false
	end

	if self.attrs.energy >= self.attrs.max_energy then
		local team
		if self.master_skill.obj_type == "enemy" then
			team = 1 + self.team
			if team == 3 then
				team = 1
			end
		else
			team = self.team
		end

		local skill_des = nil
		local skill_pos = nil
		if self.master_skill.u_range > 0 then
			if self.master_skill.u_type == "obj" then
				local obj = gameplay:near_actor_in(team,self.pos,self.pos,self.master_skill.u_range)
				if obj then
					skill_des = obj
					skill_pos = obj.pos
				end
			else
				local obj = gameplay:near_actor(team,self.pos)

				--print(obj)

				if not obj then
					return false
				end

				local pos = obj.pos

				local dx= pos.x - self.pos.x
				local dz= pos.z - self.pos.z

				local dis_2 = dx^2 + dz^2
				local u_range2 = self.master_skill.u_range ^ 2

				if (dis_2 < u_range2) then
					skill_pos = pos
				else
					local range = self.master_skill.u_range
					local dis = math.sqrt(dis_2)
					skill_pos = Vector3(self.pos.x+range*dx/dis,
										0,
										self.pos.z+range*dz/dis)
				end
			end
		else
			skill_pos = self.pos
			skill_des = self
		end

		if skill_pos then
			local params = {}
			params.pos = skill_pos
			params.objects = {skill_des}
			--print("used skill")
			self:used_skill(0,params)


			self.skill.sign = true

			if skill_des and (skill_des.team ~= self.team) then
				self.ai.lock_actor = skill_des
			end

			params = {}
			params.id = self.id
			gameplay:add_msg("used_master_skill",params)
			gameplay.pause_obj = self

			return true
		else
			return false
		end
	else
		return false
	end
end

function Class:used_skill(id,params)
	Skill.start(self,id,params)
	return true
end

function Class:is_idle()
	--print(self.skill)
	if self.skill then
		return false
	else
		if self.attrs.hp <= 0 then
			return false
		else
			return true
		end
	end
end


function Class:add_hp(value,src)

	local realValue = nil

	if value > 0 then
		if (self.attrs.hp + value) > self.attrs.max_hp then
			realValue = self.attrs.max_hp - self.attrs.hp
			self.attrs.hp = self.attrs.max_hp
		else
			self.attrs.hp = self.attrs.hp + value
		end
	else
		if self.attrs.hp + value <= 0 then
			realValue = -self.attrs.hp
			self.attrs.hp = 0
			self:on_die()
		else
			self.attrs.hp = self.attrs.hp + value
		end
	end

	if src then
		gameplay:hp_msg(src,self,value)
	else
		gameplay:hp_msg(self,self,value)
	end


	return realValue or value
end

function Class:update_temp()
	if self.is_clone_run then
		--print(self.skill)
		if self.skill then
			self.skill = self:update_thing(self.skill)
		else
			self.death = true
		end
	end
end

function Class:update()

	-- for test
	-- if self.team == 2 then
	-- 	return
	-- end

	if self.attrs.hp <= 0 then
		return
	end

	self:update_skill()
	self:update_ai()
	self:update_move()
end

function  Class:update_ai()
	if self.ai then
		self.ai = self:update_thing(self.ai)
	end
end

function  Class:update_skill()
	if self.skill then
		self.skill = self:update_thing(self.skill)
	end
end

function  Class:update_move()

	if not self.des_pos then
		return
	end

	--print(_s(self.pos),_s(self.des_pos))

	 local dis = gameplay.dt * self.attrs.speed

	 local dx = self.des_pos.x - self.pos.x
	 local dz = self.des_pos.z - self.pos.z

	 local max_dis = math.sqrt(dx*dx+dz*dz)

	 if max_dis <= dis then
		 self.pos = self.des_pos
		 self.des_pos = nil
	 else
		 local x = self.pos.x + dx * dis / max_dis
		 local z = self.pos.z + dz * dis / max_dis
		 self.pos.x = x
		 self.pos.z = z
	 end
end

function Class:update_thing(thing)
	if thing.wait_time then
		thing.wait_time = thing.wait_time - gameplay.dt
		--print(thing.wait_time)
		if thing.wait_time > 0  then
			return thing
		else
			thing.wait_time = nil
		end
	end

	g = thing
	local ret,value = coroutine.resume(thing.update)
	--print(ret,value)
	if ret then
		if value and (value >= 0) then
			thing.wait_time = value
			return thing
		end
	end

	if thing.stop then
		thing.stop(thing)
	end
	return nil
end

function Class:on_die()
	-- client play die by hp = 0
	--self:play_anim("die")
	self:stop_skill()

end

function Class:can_attack()
	return (self.attrs.hp>0)
end

return Class
