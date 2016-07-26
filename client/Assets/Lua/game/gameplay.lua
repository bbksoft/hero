
Skill 	= require("game.skill")
AI 		= require("game.ai")
Actor 	= require("game.actor")
Buff 	= require("game.buff")
Bullet  = require("game.bullet")

require("game.gamefun")

local Class = {}

findFuns = require("game.findFuns")

formula =  require("game.formula")

function Class:create()
	local obj =  {_type="gameplay"}
	Class.__index = Class
	setmetatable(obj,Class)

	return obj
end

function Class:init(send_cmd_fun,gamedata)

	Buff.init()

	local rnd_mt = require("game.rnd_mt")
    self.mt = rnd_mt.new()
    self.mt:init_genrand(gamedata.rnd_seed)
	self.rnd_seed = gamedata.rnd_seed

	self.max_id =  1
	self.actors = {}
	self.cmds = {}
	self.send_cmd_fun = send_cmd_fun

	self.temp_actors = {}

	self.now = 0
	self.dt =  0
	self.input_dt = 0
	self.count_time = gamedata.game_time

	for k,v in pairs(gamedata.actors) do
		self:create_actor(v,gamedata.self_team)
	end

	self:send_cmd()
end


function Class:update(dt)

	if self.pause_obj then
		self.dt = dt
		local obj = self.pause_obj
		obj:update_skill()
		obj:update_move()
	else
		self.count_time = self.count_time - dt
		self:check_win()
		self.now = self.now + dt
		self.dt = dt

		if not gameplay.winner then
			for _,v in pairs(self.actors) do
				v:update()
			end

			for k,v in pairs(self.temp_actors) do
				if v.death then
					self.temp_actors[k] = nil
				else
					--print(v.update_temp,v.id)
					v:update_temp()
				end
			end
		end

		Buff.update()
	end

	self:send_cmd()
end

function Class:new_id()
	self.max_id = self.max_id + 1
	return self.max_id
end

function Class:check_win()
	if gameplay.winner then
		return true
	end

	local winner = nil
	if self.count_time > 0 then
		local team_count = {}

		for _,v in pairs(self.actors) do
			if (v.attrs.hp > 0) then
				local team = v.team
				if team_count[team] then
					team_count[team] = team_count[team] + 1
				else
					team_count[team] = 1
				end
			end
		end

		if team_count[1] then
			if not team_count[2] then
				winner = 1
			end
		else
			if team_count[2] then
				winner = 2
			else
				winner = 0
			end
		end
	else
		winner = 0
	end

	if winner then
		gameplay.winner = winner
		local data = {}

		if winner ==  1 then
			data.result = 1
		elseif winner == 2 then
			data.result = -1
		else
			data.result = 0
		end

		self:add_msg("end_game",data)
		return true
	else
		return false
	end
end

function Class:near_actor(team,center)
	local find_dis = 10000000
	local find_obj  = nil

	for _,v in pairs(self.actors) do
		--print(v.attrs.hp,v.team,team)
		if (v.attrs.hp > 0) and (v.team == team) then
			local dis = dis_pos(v.pos,center) - v.cfg.radius
			--print(p_dis,find_dis)
			if dis < find_dis then
				find_dis = dis
				find_obj = v
			end
		end
	end

	return find_obj
end

function Class:near_actor_in(team,pos,center,dis)
	local find_dis = 10000000
	local find_obj  = nil

	for _,v in pairs(self.actors) do
		if (v.attrs.hp > 0) and (v.team == team) then
			local c_dis = dis_pos(v.pos,center) - v.cfg.radius
			if c_dis <= dis then
				local p_dis = dis_pos(v.pos,pos) - v.cfg.radius
				if p_dis < find_dis then
					find_dis = p_dis
					find_obj = v
				end
			end
		end
	end

	return find_obj
end

function Class:get_start_pos(team,pos_index)

	local off = cfg_position[team][pos_index]

	local x = off.x or 0
	local y = off.y or 0
	local z = off.z or 0

	return Vector3(x,y,z)
end

function Class:create_actor(data,self_team)

	data.id = self:new_id()

	local actor = Actor.create(data,self_team == data.team)
	self.actors[data.id] = actor

	self:add_msg("create",actor)
end

function Class:add_msg(cmd,params)
	table.insert(self.cmds,{cmd=cmd,params=params})
end

-- param -> pos = {x,y}, des_id = integer
function Class:set_auto(params)
	self.auto = not self.auto
end

function Class:cancel_master_skill(params)
	local player = self:find_actor(params.id)

	if player == nil then
		return false
	end
	player:stop_master_skill()
end

function Class:used_master_skill(params)

	if self.pause_obj then
		return
	end
	--print(self)
	--print(_s(params))
	self:add_msg("used_master_skill",params)

	local player = self:find_actor(params.id)

	if player == nil then
		return false
	end

	local call_params = {}
	call_params.pos = params.pos

	if params.des then
		local actor = self:find_actor(params.des)
		call_params.objects = {actor}
	else
		call_params.objects = {}
	end

	player:used_skill(0,call_params)
	self.pause_obj = player
	self:send_cmd()
end

function Class:master_skill_start(params)
	--print("master_skill_start")

	local skill = self.pause_obj.skill
	if params.des then
		local actor = self:find_actor(params.des)
		skill.objects = {actor}
		skill.pos = actor.pos

		if actor and (actor.team ~= self.pause_obj.team) then
			self.pause_obj.ai.lock_actor = actor
		end
		--print(self.pause_obj.id,actor.id)
	else
		skill.objects = {}
		skill.pos = params.pos
	end

	skill.sign = true
end

function Class:stop_master_skill(params)
	local player = self:find_actor(params.id)

	if player == nil then
		return false
	end

	player:stop_master_skill()
end




function Class:find_actor(id)
	return self.actors[id]
end

function Class:find(actor,params,list)
	local actors = clone_table(self.actors)

	if list then
	    for k, v in pairs(list) do
	        actors[v.id] = nil
	    end
	end

	for k, v in pairs(actors) do
		if v.attrs.hp <= 0 then
			actors[k] = nil
		end
	end

	return self:find_in_list(actor,actors,params)
end

function Class:find_in_list(actor,actors,params)
	for _,v in ipairs(params) do
		local len = #v
		if len == 2 then
			--print(v[1],#actors)
			local fun1 = findFuns[v[1]]
			local fun = findFuns[v[2]]
			return fun1(fun,actor,actors)
		elseif len == 3 then
			local fun = findFuns[v[2]]
			assert(fun,"not found function "..v[2])

			local fun1 = findFuns[v[1]]

			if fun1 ~= nil then
				local self_value = v[3]
				for k,another in pairs(actors) do
					local value = fun1(actor,another)
					if not fun(value,self_value) then
						actors[k] = nil
					end
				end
			else
				local self_value = actor[v[3]]
				for k,another in pairs(actors) do
					local value = another[v[1]]
					if not fun(value,self_value) then
						actors[k] = nil
					end
				end
			end
		else
			assert(false,"error format")
		end
	end

	return actors
end



function Class:send_cmd()
	self.send_cmd_fun(self.cmds)
	self.cmds = {}
end

function Class:damage(src,des,type,x_v,v)

	if x_v == nil then
		x_v = 1
	end

	if v == nil then
		v = 0
	end

	local value = formula[type.."_atk"](src.attrs,des.attrs,x_v,v)
	value = -math.floor(value)
	local real_value = des:add_hp(value)

	self:hp_msg(src,des,value)

	return (-real_value),(des.attrs.hp<=0)
end

function Class:add_hp(des,value)
	value = math.floor(value)
	des:add_hp(value)
	self:hp_msg(des,des,value)
end

function Class:hp_msg(src,des,value)
	local per = des.attrs.hp * 1.0 / des.attrs.max_hp
	--print(per,des.attrs.hp, des.attrs.max_hp)
	if src then
		self:add_msg("hp_change",{src=src.parent_id or src.id,des=des.id,value=value,per=per})
	else
		self:add_msg("hp_change",{des=des.id,value=value,per=per})
	end
end

function Class:energy_msg(actor)
	local per = actor.attrs.energy * 1.0 / actor.attrs.max_energy

	self:add_msg("energy_change",{id=actor.id,per=per})
end



function Class:add_temp(actor)
	table.insert(self.temp_actors,actor)
end

function Class:get_betweed_pos(src,des)
	local dx = des.pos.x - src.pos.x
	local dz = des.pos.z - src.pos.z

	local dis = math.sqrt(dx^2+dz^2)
	local to_dis = dis  - src.cfg.radius - des.cfg.radius - src.cfg.atk_dis

	if ( to_dis <=  0 ) then
		return nil
	else
		return Vector3(src.pos.x+dx*to_dis/dis,0,src.pos.z+dz*to_dis/dis)
	end
end

return Class
