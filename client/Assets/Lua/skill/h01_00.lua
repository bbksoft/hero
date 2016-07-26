


local buffId = 0


play_effect_key(1,"FX_skill_start",0)

play_anim("skill_2_start")
wait_anim_end()

wait("skill_2_ready")
wait_anim_end()

stop_effect(1)

play_anim("skill_2_go")
wait_anim_end()
end_pause()

play_anim("nskill_2_going")


play_effect_key(2,"paladin/FX_panadin_skill_ssph")

find_obj({
    {"team", "==", "team"},
})

buff_hold(100,"p_def",150,"m_def",150)

hold_energy(700,10)

-- while add_energy_self(-7) do
--     sleep(0.1)
-- end

stop_effect(2)

sleep(2)
