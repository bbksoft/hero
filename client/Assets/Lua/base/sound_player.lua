


sound_player = {index=0,key_data={}}


function sound_player.play(name,delay)
    if delay then
        SoundAPI.PlaySound(name,delay)
    else
        SoundAPI.PlaySound(name)
    end

    sound_player.index = sound_player.index + 1
end

function sound_player.one_play(name,inval,key)
    key = key or name

    inval = inval or 0
    local time = sound_player.key_data[key] or 0

    if time < Time.time then
        inval = inval + SoundAPI.PlaySound(name)
        sound_player.key_data[key] = Time.time + inval
    end
end

function sound_player.play_anim(hero_id,anim)
    --print(hero_id,anim)
    local t = cfg_actor_sound[hero_id]
    if t and t[anim] then
        --print(t[anim].name)
        sound_player.play( t[anim].name )
    end
end

function sound_player.play_anim_rnd(hero_id,list,rnd,key)
    local value = math.random() * 100

    for i,v in ipairs(rnd) do
        value = value - v
        local anim = list[i]
        if (value<=0) and anim then
            --print(i,anim)
            local t = cfg_actor_sound[hero_id]
            if t and t[anim] then
                if key then
                    sound_player.one_play(t[anim].name,0,key)
                else
                    sound_player.play( t[anim].name )
                end
            end
            break
        end
    end
end

function sound_player.play_music(name,delay)
    if delay then
        SoundAPI.PlayMusic(name,delay)
    else
        SoundAPI.PlayMusic(name)
    end
end

function sound_player.loop_music(name,delay)
    if delay then
        SoundAPI.PlayMusic(name,delay,true)
    else
        SoundAPI.PlayMusic(name,-1,true)
    end
end

function sound_player.stop_all()
    SoundAPI.StopAll()
    sound_player.key_data = {}
end
