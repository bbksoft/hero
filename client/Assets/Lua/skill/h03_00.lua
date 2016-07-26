
play_effect_key(1,"FX_skill_start",0)

play_anim("skill")

sleep(0.2)
wait()

sleep(0.4)
stop_effect(1)
play_effect_pos("banshee/banshee_skill_big")
sleep(0.2)

end_pause()

find_obj({
    {"team", "~=", "team"},
    {"dis_pos","<", 2.6},
})
buff_add(300,5,"lock_skill",1)

sleep(0.5)
damage("m",4.95)


sleep(2)
