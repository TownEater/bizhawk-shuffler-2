local script = {}

function script.get_gamedata()
    return {
        ['gremlins-2'] = {-- Gremlins 2 - NES
            gethp=function() return mainmemory.read_u8(0x00AD) end,
            getlc=function() return mainmemory.read_u8(0x057C) end,
            maxhp=function() return 1024 end,
        },
    }
end

return script