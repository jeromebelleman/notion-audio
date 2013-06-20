audio = {}

local function ismute()
    -- Googled for popen first, then found an example in Notion source code
    local p = io.popen('pacmd dump')
    local mute
    for l in p:lines() do
        _, _, mute = string.find(l, 'set%-sink%-mute %S+ (%a+)')
        if mute then
            if mute == 'yes' then return true else return false end
        end
    end
end

function audio.togglemute()
    local mute = ismute()
    if mute then mute = 'no' else mute = 'yes' end
    -- Googled for execute first, then checked its description in PIL
    -- FIXME ioncore.exec()?
    os.execute('pactl set-sink-mute 0 ' .. mute)
end
