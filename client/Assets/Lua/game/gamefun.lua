-- global:gameplay,player,objects,pos

-- base funtion

function obj_forword(player,pos)
	if pos._type == "actor" then
		gameplay:add_msg("face_to",{id=player.id,des=pos.id})
	else
		gameplay:add_msg("face_to",{id=player.id,pos=pos})
	end
end


function forword(param)
	obj_forword(g.player,param)
end


function shake(time,power)
	GameAPI.Shake(time or 0.1,power or 0.2)
end

function obj_move_to(player,pos)
	if pos._type == "actor" then
		player:move_to_no_anim(pos.pos)
	else
		player:move_to_no_anim(pos)
	end
end

function move_to(pos)
	 obj_move_to(g.player,pos)
end


function wait_move()
	while g.player:is_moving() do
		coroutine.yield(0)
	end
	gameplay:add_msg("stop_move",{id=g.player.id})
end


function obj_move_to_speed(player,pos,speed)
	if pos._type == "actor" then
		player:move_to(pos.pos,speed)
	else
		player:move_to(pos,speed)
	end
end

function move_to_speed(pos,speed)
	obj_move_to_speed(g.player,pos,speed)
end



function obj_move_to_time(player,pos,time)
	if pos._type == "actor" then
		pos = pos.pos
	end

	local dis = dis_pos(pos,player.pos)
	local speed = dis / time

	player:move_to_no_anim(pos,speed)
end

function move_to_time(pos,time)
	obj_move_to_time(g.player,pos,time)
end

function move_to_des(speed)
	local pos = gameplay:get_betweed_pos(g.player,g.objects[1])
	if pos then
		--print(_s(pos))
		--print(g.objects[1].id)
		move_to_speed(pos,speed)
	else
		obj_forword(g.player,g.objects[1].pos)
	end
end

function move_to_des_time(time)
	local pos = gameplay:get_betweed_pos(g.player,g.objects[1])
	if pos then
		move_to_time(pos,time)
	else
		obj_forword(g.player,g.objects[1].pos)
	end
end

function kill_bonus(type,value)
	if not g.kill_bonus then
		g.kill_bonus = {}
	end

	table.insert(g.kill_bonus,{type,value})
end

function sleep(time)
	if g.index ~= 0 then
		time = time / g.player.attrs.atk_speed
	end

	if g.anim_time then
		g.anim_time = g.anim_time - time
	end
	coroutine.yield(time)
end

function wait(anim)
	local time = 0

	--if g.player.used_ai then
	--	g.sign = true
	--end

	if anim then
		play_anim(anim)
		time = g.anim_time
	else
		pause_anim()
	end

	coroutine.yield(time)
	while not g.sign do
		coroutine.yield(time)
	end

	resume_anim()
	g.sign = nil

	if g.index == 0 then
		g.player:add_energy(-cfg_master_skill[g.player.type_id].energy)
	end
end

function resume_anim()
	g.player:resume_anim()
end

function pause_anim()
	g.player:pause_anim()
end

function wait_anim_end()
	--print(g.anim_time)
	if g.anim_time then
		local time = g.anim_time
		g.anim_time = nil
		coroutine.yield(time)
	end
end

function stop()
	coroutine.yield(-1)
end

function check_chance(value)
	if value <= 0 then
		return false
	end
	if value >= 1 then
		return true
	end

	local rnd = gameplay.mt:genrand_real2()

	return  rnd < value
end


function damage_obj(obj,type,dx,value)
	g:damage(obj,type,dx,value)
end

function damage(type,dx,value)
	for _,v in pairs(g.objects) do
		damage_obj(v,type,dx,value)
	end
end



function buff_add(id,duration,...)
	for _,v in pairs(g.objects) do
		Buff.add(id,duration,v,...)
	end
end

function attrs(k)
	return g.player.attrs[k]
end

function add_attr(k,value)
	g.player:add_attr(k,value)
end

function add_hp(hp)
	for _,v in pairs(g.objects) do
		gameplay:add_hp(v,hp)
	end
end


function buff_hold(id,...)
	local buffs = {}
	for _,v in pairs(g.objects) do
		local b = Buff.add(id,999,v,...)
		if b then
			table.insert(buffs,	b)
		end
	end

	g.hold_buffs = buffs
end


function add_energy_self(value)
	if value < 0 then
		local result = g.player.attrs.energy + value
		if result < 0 then
			g.player:add_energy(-g.player.attrs.energy)
			return false
		end
	end

	g.player:add_energy(value)

	return true
end

function add_energy(value)
	for _,v in pairs(g.objects) do
		v:add_energy(value)
	end
end

function obj_add_energy(obj,value)
	obj:add_energy(value)
end


function hold_energy(energy,maxTime)
	local timeS = gameplay.now

	g:add_end( function(hand)

	    local dTime = gameplay.now - timeS

	    if dTime < maxTime then
	        local d
	        if hand then
	            d = 1
	        else
	            d = 0.5
	        end

	        local e = d * energy * (maxTime - dTime)/ maxTime
	        add_energy_self(e)
	    end
	end )

	add_energy_self(-energy)

	sleep(maxTime)
end

function find_obj(Q,list)
	local actors = gameplay:find(g.player,Q,list)

	--print(actors)
	if not actors then
		g.objects = {}
	elseif actors._type then
		g.objects = {actors}
	else
		g.objects  = {}
		for _, v in pairs(actors) do
			table.insert(g.objects,v)
		end
	end

	if #g.objects == 0 then
		--print("stop....")
		stop()
	end
end

function find_obj_other(Q)
	find_obj(Q,g.objects)
end



function find_obj_no_me(Q)
	local list = {g.player}
	find_obj(Q,list)
end

function obj_play_effect(obj,effect,node)
	gameplay:add_msg("play_effect",{id=obj.id,res=effect,node=node})
end

function play_effect(effect,node)
	obj_play_effect(g.player,effect,node)
end

function play_effect_key(key,effect,node)
	local eid = gameplay:new_id()
	if not g.eids then
		g.eids = {}
	end
	g.eids[key] = eid
--	print(eid)
	gameplay:add_msg("play_effect",{eid=eid,id=g.player.id,res=effect,node=node})
end

function stop_effect(key)
	if g.eids[key] then
--		print(g.eids[key])
		gameplay:add_msg("stop_effect",{eid=g.eids[key]})
		g.eids[key] = nil
	end
end


function play_effect_pos(effect,height)
	gameplay:add_msg("play_effect",{pos=g.pos,res=effect})
end


function play_effect_des(effect,node)
	for _,v in pairs(g.objects) do
		--print(g.player.id,v.id)
		obj_play_effect(v,effect,node)
	end
end

function play_effect_des_hit(effect,node)
	for _,v in pairs(g.objects) do
		gameplay:add_msg("play_effect",{src=g.player.id,id=v.id,res=effect,node=node})
	end
end


function obj_play_anim(obj,anim,speed)
	obj:play_anim(anim,speed)
end

function play_anim(anim,speed)
	if not speed then
		speed = 1.0
	end

	if g.index ~= 0 then
		speed = speed * g.player.attrs.atk_speed
	end
	obj_play_anim(g.player,anim,speed)
	g.anim_time = g.player:get_anim_long(anim)
	if speed then
		g.anim_time = g.anim_time / speed
	end
end

function end_pause()
	gameplay:add_msg("end_pause")
	gameplay.pause_obj = nil
end

function create_skill(fun)
	g:clone_run(fun)
end

function create_bullet_obj(	src, des, params )


	local data = clone_table(params)

	if src._type == "actor" then
		data.src = src
	else
		data.src_pos = src
	end

	if des._type == "actor" then
		data.des = des
		g:mark_obj(des)
	else
		data.des_pos = des
	end

	data.g = g

	g.bullet = Bullet.create(data)
end

function create_bullet(	data )
	for _,v in pairs(g.objects) do
		if g.player_pos then
			create_bullet_obj(g.player_pos,v,data)
		else
			create_bullet_obj(g.player,v,data)
		end
	end
end

function get_line_pos(src,des,len)
	local dx = des.pos.x - src.pos.x
	local dz = des.pos.z - src.pos.z

	local dis = math.sqrt(dx^2+dz^2)

	if dis <= 0 then
		return Vector3(src.pos.x+len,0,src.pos.z)
	else
		return Vector3(src.pos.x+len*dx/dis,0,src.pos.z+len*dz/dis)
	end
end

function create_bullet_line( dis, data )
	for _,v in pairs(g.objects) do

		if g.player_pos then
			local pos = get_line_pos(g.player_pos,v,dis)
			create_bullet_obj(g.player_pos,pos,data)
		else
			local pos = get_line_pos(g.player,v,dis)
			create_bullet_obj(g.player,pos,data)
		end
	end
end



function wait_bullet()
	while (g.bullet and (not g.bullet.death)) do
		coroutine.yield(0)
	end
end


function des_line_effect_anim(res,node,time)
	local player = g.player_pos or g.player
	local src_id = player.parent_id or player.id
	for _,v in pairs(g.objects) do
		gameplay:add_msg("line_effect",{src=src_id,des=v.id,res=res,node=node,anim_time=time})
	end
end

function des_line_effect_node(res,src_node,node,time)
	local player = g.player_pos or g.player
	local src_id = player.parent_id or player.id
	for _,v in pairs(g.objects) do
		gameplay:add_msg("line_effect",{src=src_id,des=v.id,res=res,src_node=src_node,node=node,life_time=time})
	end
end

function des_line_effect(res,node,time)
	local player = g.player_pos or g.player
	local src_id = player.parent_id or player.id
	for _,v in pairs(g.objects) do
		gameplay:add_msg("line_effect",{src=src_id,des=v.id,res=res,node=node,life_time=time})
	end
end


function line_effect(src,des,res,node,time)
	gameplay:add_msg("line_effect",{src=src.id,des=des.id,res=res,node=node,life_time=time})
end

function play_sound(name,delay)
	gameplay:add_msg("play_sound",{res=name,delay=delay})
end
