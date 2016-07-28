


local formula = {}


function formula.p_atk(src,des,x,v)

    local xadd = src.p_atk_add or 0
    local xsub = src.p_atk_sub or 0

    local pass = src.p_pass
    local def = des.p_def

    return formula.atk(src,des,src.p_atk*x+v,xadd,xsub,pass,def)
end

function formula.m_atk(src,des,x,v)
    local xadd = src.m_atk_add or 0
    local xsub = src.m_atk_sub or 0

    local pass = src.m_pass
    local def = des.m_def

    return formula.atk(src,des,src.m_atk*x+v,xadd,xsub,pass,def)
end

function formula.atk(src,des,value,xadd,xsub,pass,def)

    local rnd = (10+src.cirt/10)/(100+des.anit_cirt)

    local xcirt =  1
    if check_chance(rnd) then
        xcirt = 1 + src.cirt_value
    end

    return value*(100+xadd)/(100+xsub)*xcirt*(100+pass)/(100+def)
end

return formula
