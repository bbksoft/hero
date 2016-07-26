
local Class = {}


function Class.create(data)
    local self = data or {}

    Class.__index = Class
    setmetatable(self,Class)

    self:init()
    return self
end

function Class:init()

    sound_player.loop_music("aow2_bgm_battle_pvp")

    self.res_name = "UI_battle"

    _ui_begin(self)


    local control = {}
    _ui_add({type="list",node_name="Heroes",control=control,data_name = "@game_client.my_heros"})
    _ui_begin(control)
        local fun = function(drag,pos,data,node)

            if drag == "down" then
                data:pre_master_skill()
            elseif drag == "up" then
                data:used_master_skill()
            elseif drag == "move" then
                data:move_master_skill(pos)
            elseif drag == "cancel" then
                data:cancel_master_skill()
            end
        end
        _ui_add({type="drag_button",node_name="Button",fun=fun})
        _ui_add({type="sprite",node_name="hero1",data_name="cfg.icon",sprite_type="HeroIcon"})
        _ui_add({type="fill",node_name="life",data_name="hp"})
        _ui_add({type="fill",node_name="ap",data_name="energy"})

        local set_ui = function(data,node)
            data.ui = node
        end
        _ui_add({type="fun",fun=set_ui})
    _ui_end()

    local fun = function()

        if not game_client.is_paused then
            game_client.speed_up = not game_client.speed_up
            if game_client.speed_up then
                game_client:set_speed(2.0)
            else
                game_client:set_speed(1.0)
            end
        end
    end
    _ui_add({type="button",node_name="button/speedup",fun=fun})

    local fun = function()
        game_client:send_server("set_auto", {})
    end
    _ui_add({type="button",node_name="button/autobattle",fun=fun})

    local fun = function(data,node)
        game_client:pause_game()
        UITools.SetChildEnable(self.node,"pause_scene",true)
    end
    _ui_add({type="button",node_name="button/pause",fun=fun})

    _ui_begin({node_name="pause_scene"},true)
        local fun = function(drag,pos,data,node)
            --game_client:continue_game()
            game_client:destroy()
            GameAPI.LoadScene(0)
            UI.close_all()
        end
        _ui_add({type="button",node_name="btn_exit",fun=fun})

        local fun = function(drag,pos,data,node)
            --game_client:continue_game()
            game_client:destroy()
            GameAPI.LoadScene(1)
            UI.close_all()
        end
        _ui_add({type="button",node_name="btn_retry",fun=fun})

        local fun = function(data,node)
            game_client:continue_game()
            node.parent.gameObject:SetActive(false)
        end
        _ui_add({type="button",node_name="btn_continue",fun=fun})
    _ui_end()

    _ui_end()
end


return Class
