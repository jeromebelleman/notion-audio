audio = {}

local function ismute()
    -- Googled for popen first, then found an example in Notion source code
    local p = io.popen('pacmd dump')
    local mute
    for l in p:lines() do
        _, _, mute = string.find(l, 'set%-sink%-mute %S+analog%S+ (%a+)')
        if mute then
            return mute == 'yes'
        end
    end
end

local function volume()
    local p = io.popen('pacmd dump')
    local volume
    for l in p:lines() do
        _, _, volume = string.find(l, 'set%-sink%-volume %S+analog%S+ (%S+)')
        if volume then
            return tonumber(volume)
        end
    end
end

function audio.togglemute()
    local mute = ismute()
    if mute then mute = 'no' else mute = 'yes' end
    ioncore.exec('pactl set-sink-mute ' .. audio.sink .. ' ' .. mute)
end

function audio.up()
    ioncore.exec('pactl set-sink-volume -- ' .. audio.sink .. ' +5%')
end

function audio.down()
    ioncore.exec('pactl set-sink-volume -- ' .. audio.sink .. ' -5%')
end

function audio.getsink()
    local pipe = io.popen('pactl list short sinks')
    for line in pipe:lines() do
        _, _, sink = string.find(line, '(%d+)%s+%S+analog%S+')
        if sink then
            return sink
        end
    end
end

defbindings("WMPlex.toplevel", {
    bdoc("Increase volume."),
    kpress(META.."plus", "audio.up()"),

    bdoc("Decrease volume."),
    kpress(META.."minus", "audio.down()"),

    bdoc("Mute volume."),
    kpress(META.."Mod1+minus", "audio.togglemute()"),
})

audio.sink = audio.getsink()
