


play_anim("skill_1")



sleep(0.5)

find_obj({
    {"team","==","team"},
    {"min","hp_per"}
})

play_effect_des("paladin/FX_skill_001")

add_energy_self(100)

buff_add(102,5,"p_def",30)
local value = attrs("m_atk") * 3.5
add_hp(value)

sleep(2)
