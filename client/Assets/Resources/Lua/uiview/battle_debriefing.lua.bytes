

local Class = {}


function Class.create(data)
    local self = data or {}

    Class.__index = Class
    setmetatable(self,Class)

    self:init()
    return self
end

function Class:init()
    --print("UI_battle_debriefing")

    if self.show_state == 1 then
        sound_player.play_music("aow2_bgm_report_win")
    elseif self.show_state == -1 then
        sound_player.play_music("aow2_bgm_report_lost")
    else
        sound_player.play_music("aow2_bgm_report_draw")
    end

    self.res_name = "UI_battle_debriefing_new"

    _ui_begin(self)
        local fun = function()
            if self.show_state == 1 then
                self.show_state = 0
                UITools.SetChildEnable(self.node,"pvp",true)
                UITools.SetChildEnable(self.node,"battle_compare",false)
            else
                self:quit()
            end
        end
        _ui_add({type="button",node_name="Button_Close",fun=fun})


        self.show_state = 0
        local view_fun = function(data,node)
            if self.show_state == 1 then
                UITools.SetChildEnable(node,"pvp",false)
                UITools.SetChildEnable(node,"battle_compare",true)
            else
                UITools.SetChildEnable(node,"pvp",true)
                UITools.SetChildEnable(node,"battle_compare",false)
            end
        end
        _ui_add({type="fun",fun=view_fun})

        local max_atk = 1

        for k,v in pairs(game_client.my_heros) do
            if max_atk < v.atk_count then
                max_atk = v.atk_count
            end
        end

        for k,v in pairs(game_client.other_heros) do
            if max_atk < v.atk_count then
                max_atk = v.atk_count
            end
        end


        local control = {}
        _ui_add({type="list",node_name="battle_compare/HERO",control=control,data_name = "@game_client.my_heros"})
        _ui_begin(control)
            _ui_add({type="sprite",node_name="hero1",data_name="cfg.icon",sprite_type="HeroIcon"})
            _ui_add({type="text",node_name="Text_exp",data_name="atk_count"})
            local fun = function(data,node)
                UITools.SetFill(node,data.atk_count*1.0/max_atk)
            end
            _ui_add({type="fun",node_name="EXP",fun=fun})
        _ui_end()

        local control = {}
        _ui_add({type="list",node_name="battle_compare/HERO_OTHER",control=control,data_name = "@game_client.other_heros"})
        _ui_begin(control)
            _ui_add({type="sprite",node_name="hero1",data_name="cfg.icon",sprite_type="HeroIcon"})
            _ui_add({type="text",node_name="Text_exp",data_name="atk_count"})
            local fun = function(data,node)
                UITools.SetFill(node,data.atk_count*1.0/max_atk)
            end
            _ui_add({type="fun",node_name="EXP",fun=fun})
        _ui_end()

        _ui_begin({node_name="pvp"},true)

            local fun = function()
                self.show_state = 1
                UITools.SetChildEnable(self.node,"pvp",false)
                UITools.SetChildEnable(self.node,"battle_compare",true)
            end
            _ui_add({type="button",node_name="BUTTON/COMPARE",fun=fun})

            local fun = function()
                self:quit()
            end
            _ui_add({type="button",node_name="BUTTON/EXIT",fun=fun})


            local data = nil
            local color
            if self.result == 1 then
                data = "Victory"
                color = Color(0,1,0)
            elseif self.result == -1 then
                data = "Defeated"
                color = Color(1,0,0)
            else
                data = ""
                color = Color(1,0,0)
            end
            _ui_add({type="text",node_name="attacker/result",data=data,color=color})

            local data = nil
            if self.result == -1 then
                data = "Victory"
                color = Color(0,1,0)
            elseif self.result == 1 then
                data = "Defeated"
                color = Color(1,0,0)
            else
                data = ""
            end
            _ui_add({type="text",node_name="defender/result",data=data,color=color})

            local data = nil
            if self.result == 0 then
                data = "Draw"
                color = Color(1,1,0)
            else
                data = ""
                color = Color(0,1,0)
            end
            _ui_add({type="text",node_name="result_Draw",data=data,color=color})


            local control = {}
            _ui_add({type="list",node_name="attacker/HERO",control=control,data_name = "@game_client.my_heros"})
            _ui_begin(control)
                _ui_add({type="sprite",node_name="hero1",data_name="cfg.icon",sprite_type="HeroIcon"})
            _ui_end()

            local control = {}
            _ui_add({type="list",node_name="defender/HERO",control=control,data_name = "@game_client.other_heros"})
            _ui_begin(control)
                _ui_add({type="sprite",node_name="hero1",data_name="cfg.icon",sprite_type="HeroIcon"})
            _ui_end()

        _ui_end()

    _ui_end()
end

function Class:quit()
    game_client:destroy()
    UI.close_all()
    GameAPI.LoadScene(0)
end

return Class
