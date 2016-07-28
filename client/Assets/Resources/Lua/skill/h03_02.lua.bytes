play_anim("critical")

sleep(0.5)

local pos = g.objects[1].pos

local fun = function(obj)
    damage_obj(obj,"m",1.6)
    obj_add_energy(obj,-100)
end

add_energy_self(100)
create_bullet_line(10,{
    res = "banshee/banshee_skill_s",
    node = 0.5,
    --effect = "banshee/banshee_hiteffect",
    enode = 0.5,
    speed = 4,
    radius = 1,
    on_coll = fun,
})

sleep(2)
