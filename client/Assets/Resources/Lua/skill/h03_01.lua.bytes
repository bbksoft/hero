
play_anim("attack")
sleep(0.5)

local fun = function(obj)
    damage_obj(obj,"m",1.0)
end

add_energy_self(100)
create_bullet( {
    res = "banshee/banshee_bullet",
    node = 0.5,
    effect = "banshee/banshee_hiteffect",
    enode = 0.5,
    speed = 15,
    on_end = fun
})

sleep(2)
