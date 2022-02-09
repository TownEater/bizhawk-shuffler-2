local script = {}

function script.get_gamedata()
    return {
        ['sonic'] = {-- Sonic 1 - Megadrive
            gethp=function() return mainmemory.read_u16_be(0xFE20) end,
            getlc=function() return mainmemory.read_u8(0xFE12) end,
            maxhp=function() return 1024 end,
        },
    }
end

return script