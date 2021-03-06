
local ActorClient = {}


function  ActorClient.create(params)
    local cfg = cfg_actor[params.type_id]
	local obj = load_gameobject("actor/" .. cfg.res)

	obj.name = "" .. params.id

    local size = cfg.size
    obj.transform.localScale = Vector3(size,size,size);

    -- TODO: now used client coll ?
    GameAPI.AddNavColl(obj,cfg.radius)

	local anim = obj:GetComponent(typeof(Animation))


	local actor = {
		id = params.id,
        type_id = params.type_id,
        team = params.team,
		obj = obj,
		speed = params.attrs.speed,
        base_speed  = params.attrs.speed,
		pos   = params.pos:Clone(),
        pos_index = params.pos_index,
		anim = anim,
		next_anim    = "idle",
        --hp =  params.attrs.hp,
		cfg = cfg,
        _type = "actor",
        master_skill = cfg_master_skill[params.type_id],
        effects = {},

        energy = 0,
        hp  = 1,

        atk_count = 0,
	}

    if game_client.starttime then
        local dis = cfg_start.distance.value
        actor.des_pos = actor.pos:Clone()

        if params.team == 1 then
            actor.pos  = actor.pos - Vector3(dis,0,0)
            obj.transform.forward = Vector3(1,0,0)
        else
            actor.pos  = actor.pos - Vector3(-dis,0,0)
            obj.transform.forward = Vector3(-1,0,0)
        end
    end

    obj.transform.position = actor.pos

    actor.speed = cfg_start.speed.value

    ActorClient.__index = ActorClient
    setmetatable(actor,ActorClient)

    actor:init()

    return actor
end

function  ActorClient:init()
    self.flash_obj = load_gameobject("obj/flash",self.obj)
    self.shadow = load_gameobject("obj/shadow",self.obj)
    if self.team == 1 then
        self.hp_obj = UITools.FllowUI(self.obj,"Game/head_ui_1")
        GameAPI.SetCameraFollow(self.obj,Vector3(-20,20,-20))
    else
        self.hp_obj = UITools.FllowUI(self.obj,"Game/head_ui_2")
        self.hp_obj.gameObject:SetActive(false)
    end
    --self.hp_obj.gameObject:SetActive(false)
end

function ActorClient:destroy()
    GameObject.Destroy(self.hp_obj.gameObject)
    GameObject.Destroy(self.obj)
    game_client.actors[self.id] = nil
end

function  ActorClient:play_anim(anim,speed)
    self.next_anim = anim
    self.next_anim_speed = speed
end

function  ActorClient:real_anim(anim)
    self.next_anim = nil
    self.cur_anim = anim
    GameAPI.RealAnim(self.obj,anim)
    sound_player.play_anim(self.type_id,anim)
end

function  ActorClient:real_anim_quit()
    GameAPI.RealAnimQuit(self.obj)
end

function  ActorClient:try_play_anim(anim)
    if self.next_anim then
         return
    end

    if self.cur_anim ~= "idle" then
        return
    end
    self:play_anim(anim)
end


function ActorClient:energy_change(per)
    --self.hp = self.hp + value
    self.energy = per
    --print(game_client.ui_battle)
    --UI.refresh(game_client.ui_battle)
end

function ActorClient:hp_change(value,per)
    --self.hp = self.hp + value
    self.hp = per

	self:show_hp_change(value)

    --print(game_client.ui_battle)
    --UI.refresh(game_client.ui_battle)

    -- if not self.hp_show_time then
    --     self.hp_obj.gameObject:SetActive(true)
    -- end

    if value < 0 then
        if (not self.next_anim ) and self.cur_anim == "idle" then
            self:play_anim("hit")
		end
    end

    self.hp_show_time = 3
    UITools.SetHPAnim(self.hp_obj,self.hp)
    self.hp_obj.gameObject:SetActive(true)

    if self.hp <= 0 then
        self.hp_obj.gameObject:SetActive(false)
        self.shadow:SetActive(false)
    end
    --print(self.hp)
end

function ActorClient:show_hp_bar()
    if self.hp_show_time and self.hp_show_time > 1 then
        -- nothing
    else
        self.hp_show_time = 1
        self.hp_obj.gameObject:SetActive(true)
    end
end


function ActorClient:light_dis(v,light_dis)
    UITools.ChangeObjLight(self.obj,v)

    if not light_dis then
        if v then
            if self.team == 1 then
                self.hp_obj_ex = UITools.FllowUI(self.obj,"Game/head_ui_1",true)
            else
                self.hp_obj_ex = UITools.FllowUI(self.obj,"Game/head_ui_2",true)
            end
            UITools.SetHPAnimAtOnce(self.hp_obj_ex,self.hp)
        else
            if self.hp_obj_ex then
                GameObject.Destroy(self.hp_obj_ex.gameObject)
                self.hp_obj_ex = nil
            end
        end
    end
end

function ActorClient:show_hp_change(value,is_double)

    local res = nil

    if value > 0 then
        return --res = "hp_a"
    elseif is_double then
        res = "hp_x"
        value = -value
        self.flash_obj:SetActive(true)
    else
        res = "hp"
        value = -value
        self.flash_obj:SetActive(true)
    end

    if self.team ~= game_client.self_team then
        res = res .. "_1"
    end

    res = "game/" .. res

    local ui = UITools.ShowTextFrom3D(self.obj,res,tostring(value))

    local x = (math.random()-0.5) * 100
    local y = (math.random()-0.5) * 50
    GameAPI.AddOffAnim(ui.gameObject,Vector3(x,y,0))

	--local res = Resources.Load("obj/hp")
	--local obj = Object.Instantiate(res)s
	--GameAPI.SetText(obj,tostring(value))
    --local pos = GameAPI.GetPosIn(self.obj,1)
    --obj.transform.localPosition = pos
end

function ActorClient:face_to(value)

    local pos

    if value._type == "actor" then
        pos = value.pos:Clone()
    else
        pos = value:Clone()
    end

    pos:Sub(self.pos)
    pos.y = 0

    if (pos.x^2+pos.z^2) >= 0.000001 then
        self.obj.transform.forward = pos
    end
end


function ActorClient:EnableHintAnimId(id)
    if self.oldHintAnim ~= id then

        if self.oldHintAnimObj then
            UITools.SetEnable(self.oldHintAnimObj,false)
            self.oldHintAnimObj = nil
        end

        if id then
            self.oldHintAnimObj = self.ui:FindChild("eff_icon_0"..id)
            UITools.SetEnable(self.oldHintAnimObj,true)
        end

        self.oldHintAnim = id
    end
end

function ActorClient:update()

    -- if self.ui then
    --     if self.hp <= 0 then
    --         self:EnableHintAnimId(4)
    --     elseif self.hp <= 0.2 then
    --         self:EnableHintAnimId(3)
    --         sound_player.one_play("aow2_sfx_hplow_alert")
    --     elseif self.energy >= 1 then
    --         self:EnableHintAnimId(2)
    --     else
    --         self:EnableHintAnimId()
    --     end
    --
    --     local child_e = self.ui:FindChild("eff_icon_01")
    --     local child_btn = self.ui:FindChild("Button")
    --     if self:CanUsedMasterSkill() then
    --         UITools.SetEnable(child_e,true)
    --         UITools.SetEnableDrag(child_btn,true)
    --     else
    --         UITools.SetEnable(child_e,false)
    --         UITools.SetEnableDrag(child_btn,false)
    --     end
    -- end

    if self.hp <= 0 then
        if self.cur_anim ~= "die" then
            --if self.hp_show_time then
            self.hp_obj.gameObject:SetActive(false)
            --    self.hp_show_time = nil
            --end
            self.cur_anim = "die"
    		--self.anim:Play(self.cur_anim)
            self.anim:CrossFade(self.cur_anim)
        else
            if GameAPI.IsAnimEnd(self.anim,self.cur_anim) then
                -- local a = self.die_alpha or 1
                --
                -- if ( a > 0 ) then
                --     a =  a - 0.5 * Time.deltaTime
                --     if a > 0 then
                --         GameAPI.SetAlpha(self.obj,a)
                --     else
                --         self.obj:SetActive(false)
                --     end
                --     self.die_alpha = a
                -- end
                --self.obj:SetActive(false)

                self:destroy()
            end
        end
		return
	end

    -- if self.hp_show_time then
    --
    --     self.hp_show_time = self.hp_show_time - Time.deltaTime
    --     if self.hp_show_time <= 0 then
    --         self.hp_obj.gameObject:SetActive(false)
    --         self.hp_show_time = nil
    --     end
    -- end

	if  not self.next_anim then
		if self.cur_anim and (self.cur_anim ~= "idle") then
            --print(self.anim[self.cur_anim].time)
			--if not self.anim:IsPlaying(self.cur_anim) then
            if GameAPI.IsAnimEnd(self.anim,self.cur_anim) then
                self:play_anim("idle")
			end
		else
			self:play_anim("idle")
		end
	end

    self:update_move()

	if self.next_anim then
		self.cur_anim = self.next_anim

        local speed = 1
        if self.next_anim_speed then
            speed = self.next_anim_speed
            self.next_anim_speed = nil
        end

        --GameAPI.PlayAnim(self.anim,self.cur_anim,speed)
        GameAPI.CrossFade(self.anim,self.cur_anim,speed)

        sound_player.play_anim(self.type_id,self.cur_anim)

		self.next_anim = nil
	end

end

function ActorClient:update_move(dt)
    if self.des_pos then
		local next_pos,forword = self:get_next_pos(dt)


		if next_pos == nil then
			self.des_pos = nil
            if not self.move_no_anim then
                self:play_anim("idle")
            end
		else
            if not self.move_no_anim then
    			if self.cur_anim ~= "run" then
    				self:play_anim("run")
    			end
            end

			self.pos = next_pos
			self.obj.transform.position = next_pos
			self.obj.transform.forward =  forword

			if next_pos == des_pos then
				self.des_pos = nil
                if not self.move_no_anim then
                    self:play_anim("idle")
                end
			end
		end
	end
end

function  ActorClient:get_next_pos(dt)
     dt = dt or Time.deltaTime

	 local dis = dt * self.speed

	 local dx = self.des_pos.x - self.pos.x
	 local dz = self.des_pos.z - self.pos.z

	 local max_dis = math.sqrt(dx*dx+dz*dz)

	 if max_dis <= 0.0001 then
		 return nil
	 end

	 if max_dis <= dis then
		 return self.des_pos,Vector3(dx,0,dz)
	 else
		 local x = self.pos.x + dx * dis / max_dis
		 local z = self.pos.z + dz * dis / max_dis
		 return Vector3(x,0,z),Vector3(dx,0,dz)
	 end
end


function ActorClient:show_des_range()
    if self.master_skill.d_range > 0 then
        if  game_client.skill_pos then
            local size = self.master_skill.d_range
            game_client.range_des.transform.localScale = Vector3(size,1,size)
            game_client.range_des.transform.localPosition = game_client.skill_pos
            game_client.range_des:SetActive(true)
        else
            game_client.range_des:SetActive(false)
        end
    else
        game_client.range_des:SetActive(false)
    end

    if (self.master_skill.u_type == "obj") and game_client.skill_des then
        --game_client.sel_obj.transform.localScale = Vector3(size,size,size)
        game_client.sel_obj.transform.localPosition = game_client.skill_pos
        game_client.sel_obj:SetActive(true)
    else
        game_client.sel_obj:SetActive(false)
    end
end

function ActorClient:get_enemy()
    local team = 1 + self.team
    if team == 3 then
        team = 1
    end
    local obj = game_client:near_actor(team,self.pos)
    return obj
end

function ActorClient:get_des(pos,not_show_range)

    local team
    if self.master_skill.obj_type == "enemy" then
        team = 1 + self.team
        if team == 3 then
            team = 1
        end
    else
        team = self.team
    end

    if self.master_skill.u_range > 0 then

        if self.master_skill.u_type == "obj" then
            --print(self.master_skill.obj_type,team)
            --print(self.team,team,self.master_skill.obj_type)
            local obj = game_client:near_actor_in(team,pos,self.pos,self.master_skill.u_range)
            if obj then
                game_client.skill_des = obj
                game_client.skill_pos = obj.pos
            else
                game_client.skill_des = nil
                game_client.skill_pos = nil
            end
        else
            local dx= pos.x - self.pos.x
            local dz= pos.z - self.pos.z

            local dis_2 = dx^2 + dz^2
            local u_range2 = self.master_skill.u_range ^ 2

            if (dis_2 < u_range2) then
                game_client.skill_pos = pos
            else
                local range = self.master_skill.u_range
                local dis = math.sqrt(dis_2)
                game_client.skill_pos = Vector3(self.pos.x+range*dx/dis,
                                                0,
                                                self.pos.z+range*dz/dis)
            end

            game_client.skill_des = nil
        end
    else
        game_client.skill_pos = self.pos
        game_client.skill_des = self
    end

    game_client.skill_pos.y = 0

    local objs = nil
    if game_client.skill_pos then
        objs = game_client:actor_in(team,game_client.skill_pos,self.master_skill.d_range)
    else
        objs = {}
    end
    objs[self.id]=self

    for k,v in pairs(game_client.light_objs) do
        if not objs[k] then
            v:light_dis(false)
        end
    end

    for k,v in pairs(objs) do
        if not game_client.light_objs[k] then
            v:light_dis(true,not_show_range)
        end
    end

    game_client.light_objs = objs

    if not not_show_range then
        self:show_des_range()
    end
end

function ActorClient:CanUsedMasterSkill()

    if self.hp <= 0 then
        return false
    end

    if self.lock_skill then
        return false
    end

    if self.energy < 1 then
        return false
    end

    local size = self.master_skill.u_range

    if size <= 0  then
        return true
    end

    if self.master_skill.u_type == "pos" then
        return true
    end

    local team
    if self.master_skill.obj_type == "enemy" then
        team = 1 + self.team
        if team == 3 then
            team = 1
        end
    else
        team = self.team
    end

    local pos = self.pos

    local obj = game_client:near_actor_in(team,pos,self.pos,self.master_skill.u_range)
    if obj then
        return true
    else
        return false
    end
end

function ActorClient:cancel_master_skill()
    if game_client.pre_used_skill then
        game_client:send_server("cancel_master_skill", {id=self.id})
    end
end

function ActorClient:pre_master_skill()

    if game_client.is_paused then
        return false
    end

    if not self:CanUsedMasterSkill() then


        if self.master_skill.need_link then

            game_client:send_server("stop_master_skill", {id=self.id})
        end

        return false
    end

    game_client:send_server("used_master_skill", {id=self.id,client=true})

    return true
end

function ActorClient:used_skill(id)
    game_client:send_server("used_skill",{id=self.id,skill_id=id})
end

function ActorClient:used_master_skill()
    if game_client.pre_used_skill then
        if game_client.skill_des then
            game_client:send_server("master_skill_start",{id=self.id,pos=game_client.skill_pos,des=game_client.skill_des.id})
        else
            game_client:send_server("master_skill_start",{id=self.id,pos=game_client.skill_pos})
        end
        game_client.pre_used_skill = nil
    end
end

function ActorClient:move_master_skill(pos)
    if game_client.pre_used_skill then
        self:get_des(pos)
    end
end

function ActorClient:pause_anim(value)
    GameAPI.PauseAnim(self.obj,value)
end

function ActorClient:add_effect(res,pos)
    if self.effects[res] then
        self.effects[res].count = self.effects[res].count + 1
    else
        self.effects[res] = {}
        local obj = load_gameobject("effect/"..res)
        self.effects[res].obj = obj
        self.effects[res].count = 1

        GameAPI.AddPosInParent(obj,self.obj,pos)
    end
end

function ActorClient:del_effect(res,pos)
    if self.effects[res] then
        self.effects[res].count = self.effects[res].count - 1

        if self.effects[res].count <= 0 then
            GameObject.Destroy(self.effects[res].obj)
            self.effects[res] = nil
        end
    end
end


return ActorClient
