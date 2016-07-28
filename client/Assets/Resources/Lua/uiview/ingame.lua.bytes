
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

    self.res_name = "Ingame"
    self.data = gameplay

    _ui_begin(self)
        self.ui_level = _ui_add({type="text",node_name="Level",data_name="level"})
        local fun = function(data,node)
            game_client:used_skill(3)
        end
        _ui_add({type="button",node_name="BtnSkill",fun=fun})
    _ui_end()
end

function Class:refresh_level()
    self:refresh_child(self.ui_level)
end


return Class
