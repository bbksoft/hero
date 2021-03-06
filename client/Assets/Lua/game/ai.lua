

Class = {}

function Class.create(actor,is_self)
    local ret = {
        wait_time = 0,
        actor = actor,
    }

    Class.__index = Class
    setmetatable(ret,Class)

    local fun_real = nil

    if ( is_self ) then
        fun_real = function()
            while(true)
            do
                local time = ret:self_update()
                --print("time",time)
                coroutine.yield(time)
            end
        end
    else
        fun_real = function()
            while(true)
            do
                local time = ret:ai_update()
                --print("time",time)
                coroutine.yield(time)
            end
        end
    end

    local fun = function()
        my_call(fun_real)
    end
    ret.update = coroutine.create(fun)

    return ret
end

function Class:ai_update()
    if self.actor.attrs.hp <= 0  then
        return 1
    end
    if test_no_ai then
        return 1
    else
        if self.actor.skill or self.actor.des_pos then
            self.skill_enable_time = gameplay.now + 2
        end

        --return self:try_used_skill() or self:base_update()
        return self:base_update()
    end
end

function Class:self_update()
    if self.actor.attrs.hp <= 0  then
        return 1
    end

    if gameplay.auto then
        return self:try_used_skill() or self:base_update()
    else
        return self:base_update()
    end
end

function Class:base_update()
    local time = 0.1
    if self.actor:is_idle() then
        local actor = gameplay:find(self.actor,
                            {   {"team","~=","team"},
                                {"min","dis"}
                            })

        self:lock_attack(actor)
        time = self:try_attack() or self:try_move() or time
    end

    return time
end

function Class:lock_attack(a)
    if self.lock_actor and self.lock_actor.attrs.hp <= 0 then
        self.lock_actor = nil
    end

    if a ~= self.lock_actor then
        if self.lock_actor then

            if self.lock_actor:can_attack() then

                local dis =  findFuns.dis(self.lock_actor,self.actor)

                if (dis - 0.000001) < self.actor.cfg.at_dis then
                    return
                end
                if (dis - 0.000001) < self.actor.cfg.atk_dis then

                    if self.actor.cfg.at_dis <= 0  then
                        return
                    end

                    local dis =  findFuns.dis(a,self.actor)
                    if dis > self.actor.cfg.at_dis then
                        return
                    end
                end
            end
        end
        self.lock_actor = a
    end
end

function Class:try_used_skill()
    if not self.actor.skill then
        if self.actor:used_master_skill() then
            return 0.2
        end
    end
end

function Class:try_attack()

    if self.skill_enable_time and self.skill_enable_time > gameplay.now then
        return false
    end

    --print(self.actor.id,self.lock_actor.id)
    if self.lock_actor then
        if self.actor:attack(self.lock_actor) then
            gameplay:add_msg("face_to",{id=self.actor.id,des=self.lock_actor.id})
            return 0.2
        end
    end
end

function Class:try_move()
    if self.lock_actor then

        local dis = findFuns.dis(self.actor,self.lock_actor)

        if dis <= self.actor.cfg.atk_dis then
            self.actor:stop_move()
            gameplay:add_msg("face_to",{id=self.actor.id,des=self.lock_actor.id})
            return 0.1
        end

        local pos = self.lock_actor.pos--GameAPI.NavPath(self.actor.pos,self.lock_actor.pos,self.lock_actor.cfg.radius)

        local left  = 0
        local right = 0
        local et    = 1

        for _,v in pairs(gameplay.actors) do
            if (v ~= self.lock_actor) and (v ~= self.actor) then
                if line_inter_circle(self.actor.pos,self.lock_actor.pos,v.pos,v.cfg.radius+self.actor.cfg.radius) then
                    local x1 = self.actor.pos.x
                    local x2 = self.lock_actor.pos.x
                    local x3 = v.pos.x
                    local y1 = self.actor.pos.z
                    local y2 = self.lock_actor.pos.z
                    local y3 = v.pos.z
                    local d = (x1-x3)*(y2-y3)-(y1-y3)*(x2-x3)
                    if d == 0 then
                        et = -et
                        right = right + 1
                        left = left + 1
                    elseif d < 0 then
                        right = right + 1
                    else
                        left = left + 1
                    end
                end
            end
        end

        if left == right then
            if left > 0 then
                pos = self:turn_pos(et)
            end
        elseif left < right then
            pos = self:turn_pos(1)
        else
            pos = self:turn_pos(-1)
        end

        --local pos = self.lock_actor.pos
        if self.actor:move_to(pos) then
            return 0.1
        end
    end
end

function Class:turn_pos(d)
    local off = self.lock_actor.cfg.radius + self.actor.cfg.radius
    local dx = self.lock_actor.pos.x - self.actor.pos.x
    local dz = self.lock_actor.pos.z - self.actor.pos.z
    local dis  = math.sqrt(dx^2+dz^2)
    local x = self.lock_actor.pos.x - off * d * dz/dis
    local z = self.lock_actor.pos.z + off * d * dx/dis

    return Vector3(x,0,z)
end

return Class
