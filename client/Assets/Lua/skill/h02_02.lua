
play_anim("critical")
sleep(0.3)

add_energy_self(100)
create_skill(function()
    --print("skill....")

    local d = {1.4,1.4*0.75,1.4*0.5}
    for i=1,3 do
        -- local fun = function(obj)
        --     damage_obj(obj,"m",d[i])
        -- end
        -- create_bullet( {
        --     res = "mage/FX_mag_002",
        --     node = 0.5,
        --     effect = "mage/FX_hit_02",
        --     enode = 0.5,
        --     speed = 10,
        --     on_end = fun
        -- })
        -- wait_bullet()
        if i == 1 then
            des_line_effect_node("mage/FX_mag_002",
                "Bip01/B_Pelvis/B_Spine/B_Spine1/B_R_Clavicle/B_R_UpperArm/B_R_Forearm/B_R_Hand/Dummy01/CANE_14/Cube",
                0.5,
                0.7)
        else
            des_line_effect("mage/FX_mag_002",0.5,0.7)
        end
        sleep(0.05)
        --play_effect_des("mage/FX_hit_02",0.5)
        damage("m",d[i])
        sleep(0.15)

        g.player_pos = g.objects[1]
        find_obj({
            {"team", "~=", "team"},
            {"mark", "==", 0},
            {"dis","<",7},
            {"min","dis"},
        })

    end
end)

sleep(2)
