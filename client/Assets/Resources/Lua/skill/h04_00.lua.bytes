
play_effect_key(1,"FX_skill_start",0)

play_anim("skill_2_start")
wait_anim_end()

wait("skill_2_weit")

stop_effect(1)

move_to_des(10)
play_anim("skill_move")
wait_move()
end_pause()

play_anim("skill_2_gp")
kill_bonus("energy",1000)

for i=1,4 do
    sleep(0.1)
    damage("p",3.25)
	play_effect_des("wolf/wolf_skill_big",0.5)
    sleep(0.2)
end


sleep(2)
