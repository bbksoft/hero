cfg_actor = {
	[1] =  {
		icon="head_paladin",
		res="paladin01",
		pos=1,
		atk_dis=1,
		at_dis=0,
		atk_speed=1,
		radius=0.6,
		speed=4,
		damaged_put=400,
		damaged_get=800,
		die_put=300,
		max_energy=1000,
		skill_loop={1,1,1,2},
	},
	[2] =  {
		icon="head_mage",
		res="mage01",
		pos=2,
		atk_dis=6.8,
		at_dis=3.4,
		atk_speed=1,
		radius=0.6,
		speed=4,
		damaged_put=400,
		damaged_get=800,
		die_put=300,
		max_energy=1000,
		skill_loop={1,2,0,1,1,2},
	},
	[3] =  {
		icon="head_banshee",
		res="banshee01",
		pos=3,
		atk_dis=10.6,
		at_dis=3.4,
		atk_speed=1,
		radius=0.6,
		speed=4,
		damaged_put=400,
		damaged_get=800,
		die_put=300,
		max_energy=1000,
		skill_loop={1,1,2,0,1,1,1,2},
	},
	[4] =  {
		icon="head_wolf",
		res="wolf01",
		pos=1,
		atk_dis=1,
		at_dis=0,
		atk_speed=1,
		radius=0.6,
		speed=4,
		damaged_put=400,
		damaged_get=800,
		die_put=300,
		max_energy=1000,
		skill_loop={1,1,1,2},
	},
}
cfg_actor_sound = {
	[1] =  {
		skill_2_start =  {
			name="aow2_sfx_paladin_skill_b_pre",
		},
		die =  {
			name="aow2_sfx_paladin_die",
		},
		voi_kill =  {
			name="aow2_sfx_paladin_kill",
		},
		voi_encourage1 =  {
			name="aow2_sfx_paladin_encourage_1",
		},
		voi_encourage2 =  {
			name="aow2_sfx_paladin_encourage_2",
		},
		voi_encourage3 =  {
			name="aow2_sfx_paladin_encourage_3",
		},
	},
	[2] =  {
		skill =  {
			name="aow2_sfx_mage_skill_b_pre",
		},
		die =  {
			name="aow2_sfx_mage_die",
		},
		voi_kill =  {
			name="aow2_sfx_mage_kill",
		},
		voi_encourage1 =  {
			name="aow2_sfx_mage_encourage_1",
		},
		voi_encourage2 =  {
			name="aow2_sfx_mage_encourage_2",
		},
		voi_encourage3 =  {
			name="aow2_sfx_mage_encourage_3",
		},
	},
	[3] =  {
		skill =  {
			name="aow2_sfx_banshee_skill_b_pre",
		},
		die =  {
			name="aow2_sfx_banshee_die",
		},
		voi_kill =  {
			name="aow2_sfx_banshee_kill",
		},
		voi_encourage1 =  {
			name="aow2_sfx_banshee_encourage_1",
		},
		voi_encourage2 =  {
			name="aow2_sfx_banshee_encourage_2",
		},
		voi_encourage3 =  {
			name="aow2_sfx_banshee_encourage_3",
		},
	},
	[4] =  {
		skill_1 =  {
			name="aow2_sfx_wolf_skill_s",
		},
		skill_move =  {
			name="aow2_sfx_wolf_skill_b",
		},
		skill_2_start =  {
			name="aow2_sfx_wolf_skill_b_pre",
		},
		die =  {
			name="aow2_sfx_wolf_die",
		},
		voi_kill =  {
			name="aow2_sfx_wolf_kill",
		},
		voi_encourage1 =  {
			name="aow2_sfx_wolf_encourage_1",
		},
		voi_encourage2 =  {
			name="aow2_sfx_wolf_encourage_2",
		},
		voi_encourage3 =  {
			name="aow2_sfx_wolf_encourage_3",
		},
	},
}
cfg_buff = {
	[100] =  {
		key=1,
		effect={"paladin/buff_paladin_02",1},
		count=2,
	},
	[102] =  {
		key=2,
		effect={"FX_buff_all",0},
		count=2,
	},
	[300] =  {
		key=3,
		effect={},
		count=2,
	},
}
cfg_start = {
	deceleration =  {
		value=1,
	},
	distance =  {
		value=10,
	},
	add_dis =  {
		value=0,
	},
	speed =  {
		value=6,
	},
	min_speed =  {
		value=5,
	},
	encourage =  {
		value=0,
	},
}
cfg_level = {
	[1] =  {
		[1] =  {
			max_hp=8000,
			p_atk=142,
			m_atk=142,
			p_pass=20,
			m_pass=20,
			p_def=55,
			m_def=30,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
		[2] =  {
			max_hp=8800,
			p_atk=156,
			m_atk=156,
			p_pass=20,
			m_pass=20,
			p_def=55,
			m_def=30,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
		[3] =  {
			max_hp=9600,
			p_atk=172,
			m_atk=172,
			p_pass=20,
			m_pass=20,
			p_def=55,
			m_def=30,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
		[4] =  {
			max_hp=10400,
			p_atk=189,
			m_atk=189,
			p_pass=20,
			m_pass=20,
			p_def=55,
			m_def=30,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
		[5] =  {
			max_hp=11200,
			p_atk=208,
			m_atk=208,
			p_pass=20,
			m_pass=20,
			p_def=55,
			m_def=30,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
	},
	[2] =  {
		[1] =  {
			max_hp=4600,
			p_atk=75,
			m_atk=202,
			p_pass=20,
			m_pass=40,
			p_def=25,
			m_def=35,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
		[2] =  {
			max_hp=5060,
			p_atk=83,
			m_atk=222,
			p_pass=20,
			m_pass=40,
			p_def=25,
			m_def=35,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
		[3] =  {
			max_hp=5520,
			p_atk=91,
			m_atk=244,
			p_pass=20,
			m_pass=40,
			p_def=25,
			m_def=35,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
		[4] =  {
			max_hp=5980,
			p_atk=100,
			m_atk=268,
			p_pass=20,
			m_pass=40,
			p_def=25,
			m_def=35,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
		[5] =  {
			max_hp=6440,
			p_atk=110,
			m_atk=295,
			p_pass=20,
			m_pass=40,
			p_def=25,
			m_def=35,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
	},
	[3] =  {
		[1] =  {
			max_hp=4000,
			p_atk=60,
			m_atk=195,
			p_pass=20,
			m_pass=30,
			p_def=30,
			m_def=55,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
		[2] =  {
			max_hp=4400,
			p_atk=66,
			m_atk=215,
			p_pass=20,
			m_pass=30,
			p_def=30,
			m_def=55,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
		[3] =  {
			max_hp=4800,
			p_atk=73,
			m_atk=237,
			p_pass=20,
			m_pass=30,
			p_def=30,
			m_def=55,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
		[4] =  {
			max_hp=5200,
			p_atk=80,
			m_atk=261,
			p_pass=20,
			m_pass=30,
			p_def=30,
			m_def=55,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
		[5] =  {
			max_hp=5600,
			p_atk=88,
			m_atk=287,
			p_pass=20,
			m_pass=30,
			p_def=30,
			m_def=55,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
	},
	[4] =  {
		[1] =  {
			max_hp=6500,
			p_atk=195,
			m_atk=82,
			p_pass=30,
			m_pass=20,
			p_def=25,
			m_def=45,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
		[2] =  {
			max_hp=7150,
			p_atk=215,
			m_atk=90,
			p_pass=30,
			m_pass=20,
			p_def=25,
			m_def=45,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
		[3] =  {
			max_hp=7800,
			p_atk=237,
			m_atk=99,
			p_pass=30,
			m_pass=20,
			p_def=25,
			m_def=45,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
		[4] =  {
			max_hp=8450,
			p_atk=261,
			m_atk=109,
			p_pass=30,
			m_pass=20,
			p_def=25,
			m_def=45,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
		[5] =  {
			max_hp=9100,
			p_atk=287,
			m_atk=120,
			p_pass=30,
			m_pass=20,
			p_def=25,
			m_def=45,
			cirt=200,
			anit_cirt=100,
			cirt_value=0.5,
		},
	},
}
cfg_position = {
	[1] =  {
		[1] =  {
			x=-8.2,
			z=4.2,
		},
		[2] =  {
			x=-4.1,
			z=4.2,
		},
		[3] =  {
			x=0,
			z=4.2,
		},
		[4] =  {
			x=-8.2,
			z=0.2,
		},
		[5] =  {
			x=-4.1,
			z=0.2,
		},
		[6] =  {
			x=0,
			z=0.2,
		},
		[7] =  {
			x=-8.2,
			z=-3.8,
		},
		[8] =  {
			x=-4.1,
			z=-3.8,
		},
		[9] =  {
			x=0,
			z=-3.8,
		},
	},
	[2] =  {
		[1] =  {
			x=2.8,
			z=4.2,
		},
		[2] =  {
			x=6.9,
			z=4.2,
		},
		[3] =  {
			x=11,
			z=4.2,
		},
		[4] =  {
			x=2.8,
			z=0.2,
		},
		[5] =  {
			x=6.9,
			z=0.2,
		},
		[6] =  {
			x=11,
			z=0.2,
		},
		[7] =  {
			x=2.8,
			z=-3.8,
		},
		[8] =  {
			x=6.9,
			z=-3.8,
		},
		[9] =  {
			x=11,
			z=-3.8,
		},
	},
}
cfg_skill = {
	[1] =  {
		[0] =  {
			script="h01_00",
			params={},
		},
		[1] =  {
			script="h01_01",
			params={},
		},
		[2] =  {
			script="h01_02",
			params={},
		},
	},
	[2] =  {
		[0] =  {
			script="h02_00",
			params={},
		},
		[1] =  {
			script="h02_01",
			params={},
		},
		[2] =  {
			script="h02_02",
			params={},
		},
	},
	[3] =  {
		[0] =  {
			script="h03_00",
			params={},
		},
		[1] =  {
			script="h03_01",
			params={},
		},
		[2] =  {
			script="h03_02",
			params={},
		},
	},
	[4] =  {
		[0] =  {
			script="h04_00",
			params={},
		},
		[1] =  {
			script="h04_01",
			params={},
		},
		[2] =  {
			script="h04_02",
			params={},
		},
	},
}
cfg_master_skill = {
	[1] =  {
		u_type="pos",
		u_range=0,
		d_range=30,
		d_type="null",
		obj_type="teammate",
		energy=300,
		need_link=true,
		pre_effect="bigskill_start",
	},
	[2] =  {
		u_type="obj",
		u_range=7.8,
		d_range=0,
		d_type="null",
		obj_type="enemy",
		energy=1000,
		need_link=false,
		pre_effect="bigskill_start",
	},
	[3] =  {
		u_type="pos",
		u_range=13,
		d_range=2.6,
		d_type="cirle",
		obj_type="enemy",
		energy=1000,
		need_link=false,
		pre_effect="bigskill_start",
	},
	[4] =  {
		u_type="obj",
		u_range=7.8,
		d_range=0,
		d_type="cirle",
		obj_type="enemy",
		energy=1000,
		need_link=false,
		pre_effect="bigskill_start",
	},
}
cfg_skill_lvl = {
	[1] =  {
		[1] =  {
			params_A={1,1,2},
			params_B={1,3,5},
		},
		[2] =  {
			params_A={1,1,2},
			params_B={1,3,5},
		},
	},
}
