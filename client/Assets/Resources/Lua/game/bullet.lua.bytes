

local Bullet = {}
Bullet.__index = Bullet

function Bullet.create(data)
    local bullet

    --print(data.pos)
    --print(data.id)
    if data.id then
        bullet = clone_table(data)
        bullet.is_client = true

        --print(bullet.pos)

        local src = game_client.actors[data.src]
        if src then
            if type(data.node) == "string" then
                bullet.pos = GameAPI.GetPosIn(src.obj,data.node)
            else
                local pos = GameAPI.GetPosIn(src.obj,data.node)
                bullet.pos = src.pos
                bullet.pos.y = pos.y

                if data.des then
                    local des = game_client.actors[data.src]
                    if des then
                        bullet.pos = line_pos(bullet.pos,des.pos,src.cfg.radius)
                    end
                elseif data.des_pos then
                    bullet.pos = line_pos(bullet.pos,data.des_pos,src.cfg.radius)
                end
            end
        end

        if data.res then
            local obj = load_gameobject("effect/" .. data.res)

            local des = game_client.actors[data.des]
            if des then
                local x = des.pos.x - data.pos.x
                local z = des.pos.z - data.pos.z

                if (x~=0) or (z~=0) then
                    obj.transform.forward = Vector3(x,0,z)
                end
            end

            obj.transform.localPosition = bullet.pos
            bullet.obj = obj

            obj.name = "" .. data.id
        end

        --print(bullet.pos)

        setmetatable(bullet,Bullet)
        game_client:add_temp(bullet)
    else
        data.id = gameplay:new_id()

        bullet = clone_table(data)

        if data.des then
            data.des = data.des.id
        end

        if data.src then
            data.src = data.src.parent_id or data.src.id
            if data.des  then
                bullet.pos = line_pos(bullet.src.pos, bullet.des.pos,bullet.src.cfg.radius)
            else
                bullet.pos = line_pos(bullet.src.pos, bullet.des_pos,bullet.src.cfg.radius)
            end
        end

        data.pos = bullet.pos

        gameplay:add_msg("create_bullet",data)

        setmetatable(bullet,Bullet)
        gameplay:add_temp(bullet)
    end

    return bullet
end

function Bullet:update_temp()
    local dt
    local actor

    if  self.is_client then
        dt = Time.deltaTime
        actor = game_client.actors[self.des]
    else
        actor = self.des
        --print(self.des)
        --print(actor)
        if actor and (actor.attrs.hp <= 0)  then
            gameplay:add_msg("end_bullet",{id=self.id})
            self.death = true
            return
        end
        dt = gameplay.dt
    end



    if actor then
        if self.is_client then
            self.des_pos = GameAPI.GetPosIn(actor.obj,self.enode)
            self.des_pos = line_pos(self.des_pos,self.pos,actor.cfg.radius-0.3)
        else
            self.des_pos = actor.pos
        end
    end

    if self.des_pos then
        self:update_move(dt)
    end
    --print(self.is_client,self.pos.x)

    if not self.is_client then

        local do_end = function()
            gameplay:add_msg("end_bullet",{id=self.id})
            if self.on_end then
                local temp = g
                g = self.g
                self.on_end(self.des)
                g = temp
            end
            self.death = true
        end

        if actor then
            local dx = actor.pos.x - self.pos.x
            local dz = actor.pos.z - self.pos.z

            if (dx^2+dz^2)  < actor.cfg.radius^2 then
                do_end()
                return
            end
        else
            if not self.des_pos then
                do_end()
                return
            end
        end
    else
        if not self.des_pos then
            self:client_end()
            return
        end
    end
end

function  Bullet:update_move(dt)
    --print(_s(self.pos),_s(self.des_pos))
	 local dis = dt * self.speed

	 local dx = self.des_pos.x - self.pos.x
	 local dz = self.des_pos.z - self.pos.z

     local old_pos  = self.pos

	 local max_dis = math.sqrt(dx*dx+dz*dz)
     --print(max_dis,dis)
	 if max_dis <= dis then
		 self.pos = self.des_pos
		 self.des_pos = nil
	 else
		 local x = self.pos.x + dx * dis / max_dis
		 local z = self.pos.z + dz * dis / max_dis

         if self.is_client then
             local y =  self.des_pos.y - self.pos.y

             if y == 0 then
                 y = self.des_pos.y
             else
                 y = self.pos.y + y * dis / max_dis
             end

             self.pos = Vector3(x,y,z)

             self.obj.transform.localPosition = self.pos
             --print(_s(self.pos))
             self.obj.transform.forward = Vector3(dx,0,dz)
         else
             self.pos = Vector3(x,0,z)
         end
	 end

     if not self.is_client then
         if self.on_coll then
             if not self.colls then
                self.colls = {}
             end
             local temp = g
             g = self.g
             for _,v in pairs(gameplay.actors) do
                 if (not self.colls[v.id]) and (v.team ~= self.src.team) then
                     if line_inter_circle(old_pos,self.pos,v.pos,v.cfg.radius) then
                         self.on_coll(v)
                         self.colls[v.id] = v
                     end
                 end
             end
             g = temp
         end
     end
end



function Bullet:on_client_end()
    self.server_end_move = true
end

function Bullet:client_end()
    if not self.server_end_move then
        return
    end

    if self.effect and (self.effect~="") then
        local params = {
            --id = self.des,
            pos  = self.pos,
            res = self.effect,
        }
        --print("play effect")
        game_client.msg_funs.play_effect(game_client,params)
    end

    if self.obj  then
        GameObject.Destroy(self.obj)
    end
    self.death = true
end

return Bullet
