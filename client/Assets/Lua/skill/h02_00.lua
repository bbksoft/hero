
play_effect_key(1,"FX_skill_start",0)

play_anim("skill")
sleep(0.1)
wait()
end_pause()

sleep(0.5)

stop_effect(1)

create_skill(function()

    local obj = g.player
    for i=1,5 do

        local fun = function(obj)
            damage_obj(obj,"m",3.6)
        end

        create_bullet( {
            res = "mage/FX_mag_001",
            node = 0.5,
            effect = "mage/FX_hit_02",
            enode = 0.5,
            speed = 4,
            on_end = fun
        })
        wait_bullet()

        g.player_pos = g.objects[1]
        find_obj_other({
            {"team", "~=", "team"},
            {"dis","<",5},
            {"min","mark"},
        })
    end
end)

sleep(2)
