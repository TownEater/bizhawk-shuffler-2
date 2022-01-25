local script = {}

function script.get_gamedata()
    return {
        ['solstice'] = {-- Solstice - NES
            gethp=function() return mainmemory.read_u8(0x0789) end,
            getlc=function() return mainmemory.read_u8(0x0789) end,
            maxhp=function() return 1024 end,
        },
    }
end

return script