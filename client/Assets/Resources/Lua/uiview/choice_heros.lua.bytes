

local Class = {}


function Class.create(data)
    local self = data or {}

    Class.__index = Class
    setmetatable(self,Class)

    self:init()
    return self
end

function Class:init()

    sound_player.loop_music("aow2_bgm_herofmt")

    self.res_name = "UI_ChooseHeroes"

    player.select_another = nil
    player.heros = player.atk_frm.heros
    player.frm   = player.atk_frm.frm

    _ui_begin(self)
        local view_select = function(data,node)
            if player.select_another then
                UI.set_child_enable_image(node,"attack",false)
                UI.set_child_enable_image(node,"defence",true)
            else
                UI.set_child_enable_image(node,"attack",true)
                UI.set_child_enable_image(node,"defence",false)
            end
        end
        _ui_add({type="fun",node_name="FORMATION",fun=view_select})

        local fun = function()
            player.select_another = not player.select_another

            if player.select_another then
                player.heros = player.def_frm.heros
                player.frm   = player.def_frm.frm
            else
                player.heros = player.atk_frm.heros
                player.frm   = player.atk_frm.frm
            end


            UI.refresh(self)
        end
        _ui_add({type="button",node_name="btns/btn_changeTeam",fun=fun})

        local fun = function()
            local count = 0

            for k,v in pairs(player.atk_frm.frm) do
                 count = count + 1
                 break
            end

            if count == 0 then
                UI.show_hint("请选择己方上阵英雄!")
                return
            end

            local count = 0
            for k,v in pairs(player.def_frm.frm) do
                 count = count + 1
                 break
            end

            if count == 0 then
                UI.show_hint("请选择对方上阵英雄!")
                return
            end

            --UITools.EnableObj("Camera")
            sound_player.play("aow2_sfx_button_fight")
            GameAPI.LoadScene(1)
            UI.close_all()
        end
        _ui_add({type="button",node_name="btns/btn_battle",fun=fun})

        local fun = function()
            UI.create("heros_lvl")
        end
        _ui_add({type="button",node_name="btns/btn_lvlUp",fun=fun})


        local control = {}
        local HeroList = _ui_add({type="list",node_name="HERO/heroes",control=control,data_name = "@player.heros"})
        _ui_begin(control)
            _ui_add({type="sprite",data_name="icon",sprite_type="HeroIcon"})
            local fun = function(index,data)

                if not data.pos_index then
                    local frm = player.frm
                    if self:get_frm_count(frm) < 5 then
                        data.pos_index= self:set_frm(frm,index)                        
                        sound_player.play_anim_rnd(data.id,{"voi_encourage1","voi_encourage2","voi_encourage3"},{30,30,30})
                        sound_player.play("aow2_sfx_hero_choose")
                    end
                else
                    sound_player.play("aow2_sfx_hero_cancel")
                    player.frm[data.pos_index] = nil
                    data.pos_index = nil
                end
                UI.refresh(self)
            end
            _ui_add({type="button_index",node_name="Button",fun=fun})
            _ui_add({type="text",node_name="Text",data_name="level"})
            _ui_add({type="enable",node_name="choosesign",data_name="pos_index"})
        _ui_end()

        local set_mod = function(heros,data,node,forward)
            if data then
                data = heros[data].id
                local obj = UITools.AddMod(node,"mod","actor/"..cfg_actor[data].res,30,forward)
                load_gameobject("obj/ui_material",obj)
            else
                UITools.DelMod(node,"mod")
            end
        end

        local view_mod_fun = function(data,node)
            set_mod(player.atk_frm.heros,data,node,Vector3(1,0,0))
        end
        local drag_fun = function(data,node,id1,id2)
            --print(id1,id2)
            if id1 == 0 then
                if data ~= player.frm then
                    player.select_another = not player.select_another

                    if player.select_another then
                        player.heros = player.def_frm.heros
                        player.frm   = player.def_frm.frm
                    else
                        player.heros = player.atk_frm.heros
                        player.frm   = player.atk_frm.frm
                    end
                    view_select(nil,self.node:FindChild("FORMATION"))
                    UI.display(HeroList,self.node)
                end
                return
            elseif id2 == 0 then
                player.heros[player.frm[id1]].pos_index = nil
                player.frm[id1] = nil
                sound_player.play("aow2_sfx_hero_cancel")
            elseif not player.frm[id1] then
                player.heros[player.frm[id2]].pos_index = id1
                player.frm[id1] = player.frm[id2]
                player.frm[id2] = nil
                local data = player.heros[player.frm[id1]]
                sound_player.play_anim_rnd(data.id,{"voi_encourage1","voi_encourage2","voi_encourage3"},{30,30,30})
            elseif not player.frm[id2] then
                player.heros[player.frm[id1]].pos_index = id2
                player.frm[id2] = player.frm[id1]
                player.frm[id1] = nil

                local data = player.heros[player.frm[id2]]
                sound_player.play_anim_rnd(data.id,{"voi_encourage1","voi_encourage2","voi_encourage3"},{30,30,30})
            else
                local temp = player.heros[player.frm[id1]].pos_index
                player.heros[player.frm[id1]].pos_index = player.heros[player.frm[id2]].pos_index
                player.heros[player.frm[id2]].pos_index = temp

                local temp = player.frm[id1]
                player.frm[id1] = player.frm[id2]
                player.frm[id2] = temp

                if math.random() > 0.5 then
                    local data = player.heros[player.frm[id1]]
                    sound_player.play_anim_rnd(data.id,{"voi_encourage1","voi_encourage2","voi_encourage3"},{30,30,30})
                else
                    local data = player.heros[player.frm[id2]]
                    sound_player.play_anim_rnd(data.id,{"voi_encourage1","voi_encourage2","voi_encourage3"},{30,30,30})
                end
            end
            UI.refresh(self)
        end
        local control = {type="fun",fun=view_mod_fun}
        _ui_add({type="list_fixed",fixed_count=9,node_name="FORMATION/attack",
                    drag_fun = drag_fun,
                    cancel_node = "../../HERO/box_edge",
                    control=control,data_name = "@player.atk_frm.frm"})


        local view_mod_fun = function(data,node)
            set_mod(player.def_frm.heros,data,node,Vector3(-1,0,0))
        end

        local control = {type="fun",fun=view_mod_fun}
        _ui_add({type="list_fixed",fixed_count=9,node_name="FORMATION/defence",
                    drag_fun = drag_fun,
                    cancel_node = "../../HERO/box_edge",
                    control=control,data_name = "@player.def_frm.frm"})
    _ui_end()
end

function Class:get_frm_count(frm)
    local count = 0
    for i=1,9 do
        if frm[i] then
            count = count + 1
        end
    end
    return count
end

function Class:set_frm(frm,id)

    local n = self:get_frm_pos(frm,id)

    frm[n] = id
    return n
end

function Class:get_frm_pos(frm,id)

    local hero = player.heros[id]

    local cfg = cfg_actor[hero.id]

    local pos = 4 - cfg.pos

    if player.select_another then
        pos = cfg.pos
    end

    if not frm[pos+3] then
        return (pos + 3)
    end

    if not frm[pos] then
        return (pos + 0)
    end

    if not frm[pos+6] then
        return (pos + 6)
    end

    if player.select_another then
        if pos == 1 then
            pos = 2
        else
            pos = pos - 1
        end
    else
        if pos == 1 then
            pos = 2
        else
            pos = pos - 1
        end
    end

    if not frm[pos+3] then
        return (pos +3)
    end

    if not frm[pos] then
        return (pos + 0)
    end

    if not frm[pos+6] then
        return (pos + 6)
    end
end

function Class:on_focus()

end

function Class:lost_focus()
    UI.hide(self)
end

return Class
