


local Buff =
{
    max_id = 0,
    datas = {},
}

function Buff.init()

end

function Buff.add(id,duration,obj,...)

    if not obj then
        return 0
    end
    --print("add buff")

    Buff.max_id = Buff.max_id + 1

    local buff = {
        id = Buff.max_id,
        type = id,
        time = gameplay.now + duration,
        params = {...},
        obj = obj
    }

    local cfg = cfg_buff[id]
    if obj.buff[cfg.key] then
        if  obj.buff[cfg.key].count < cfg.count then
            return nil
        end
        obj.buff[cfg.key].count = obj.buff[cfg.key].count + 1
    else
        obj.buff[cfg.key] = {count=1}
    end

    local len = #buff.params

    for i=1,len,2 do
        obj:add_attr(buff.params[i],buff.params[i+1])
    end

    Buff.datas[Buff.max_id] = buff

    gameplay:add_msg("buff_add",{id=buff.obj.id,type=buff.type})

    return Buff.max_id
end

function Buff.del(id)
    --print("remove buff")

    local buff = Buff.datas[id]
    if not buff then
        return
    end

    gameplay:add_msg("buff_del",{id=buff.obj.id,type=buff.type})

    local len = #buff.params

    for i=1,len,2 do
        buff.obj:add_attr(buff.params[i],-buff.params[i+1])
    end

    local cfg = cfg_buff[buff.type]
    local obj = buff.obj
    local count = obj.buff[cfg.key].count - 1

    if count <= 0 then
        obj.buff[cfg.key] = nil
    else
        obj.buff[cfg.key].count = count
    end

    Buff.datas[id] = nil
end


function Buff.update()
    for k,v in pairs(Buff.datas) do
        if v.time < gameplay.now then
            Buff.del(k)
        end
    end
end




return Buff
