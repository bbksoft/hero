
local Class = {}
Class.__index = Class

function Class.start(player,index,param)
	local cfg = cfg_skill[player.type_id][index]

	player:stop_move()
	if player.skill then
		player.skill:stop()
	end	

	param = param or {}

	local skill = {
		_type       = "skill",
		index       = index,
		gameplay = gameplay,
		player   = player,
		objects  = param.objects,
		pos  	 = param.pos,
		mark = {},
	}
	setmetatable(skill,Class)

	local skill_fun =  loadfile("skill/"..cfg.script..".lua")

	assert(skill_fun,"can't load skill:"..cfg.script)

	local fun = function()
		my_call(skill_fun)
		wait_anim_end()
	end

	skill.update 	= coroutine.create(fun)
	skill.on_end 	= nil
	skill.params = cfg.params

	player.skill = skill
end


function Class:clone_run(fun)
	local obj = self.player:clone()
	local skill  = clone_table(self)
	skill.player = obj
	obj.skill = skill

	skill.update 	= coroutine.create(function()
		my_call(fun)
	end)
	skill.on_end 	= nil

	obj.is_clone_run = true

	setmetatable(skill,Class)

	obj.parent_id = obj.id
	obj.id = gameplay:new_id()

	gameplay:add_temp(obj)
end

function Class:stop(bySelf)
	local rnd = gameplay.mt:genrand_real2()
	self.player.ai.wait_time = rnd

	if self.hold_buffs then
		for _,v in pairs(self.hold_buffs) do
			Buff.del(v)
		end
	end

	if self.eids then
		for k,v in pairs(self.eids) do
			gameplay:add_msg("stop_effect",{eid=v})
		end
		self.eids = nil
	end

	if gameplay.pause_obj  == self.player then
		gameplay:add_msg("end_pause")
		gameplay.pause_obj = nil
	end

	if self.on_end then
		local temp = g
		g = self
		for _,v in pairs(self.on_end) do
			v(bySelf)
		end
		g = temp
	end
end

function Class:add_end(fun)
	if not self.on_end then
		self.on_end = {}
	end

	table.insert(self.on_end,fun)
end

-- for call
function Class:damage(des,type,dx,value)
	local src = self.player

	local d,die = gameplay:damage(src,des,type,dx,value)

	--src:add_energy(1000000)

	if src.parent_id then
		src = gameplay.actors[src.parent_id]
	end

	if self.index ~= 0 then
		if src then
			--print(des.attrs.max_hp,des.cfg.damaged_put,d)
			src:add_energy(des.cfg.damaged_put*d/des.attrs.max_hp)
		end
	end
	if die then
		if src then
			src:add_energy(des.cfg.die_put)

			sound_player.play_anim(src.type_id,"voi_kill")

			if g.kill_bonus then
				for _,v in pairs(g.kill_bonus) do
					if v[1] == "energy" then
						src:add_energy(v[2])
					end
				end
			end

		end
	else
		des:add_energy(des.cfg.damaged_get*d/des.attrs.max_hp)
	end

	self:mark_obj(des)

	if src and (src.attrs.hp > 0) then
		local blood = src.attrs.blood
		if blood and (blood > 0 ) then
			local value = math.floor(blood*d)
			if value < 1 then
				value = 1
			end
			src:add_hp(value)
			gameplay:hp_msg(src,src,value)
		end
	end

	--print(self.mark,des.id)
end

function Class:mark_obj(des)
	if self.mark[des.id] then
		self.mark[des.id] = self.mark[des.id] + 1
	else
		self.mark[des.id] = 1
	end
end

return Class
