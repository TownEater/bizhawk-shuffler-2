local script = {}

function script.get_gamedata()
    return {
        ['gradius'] = {-- Gradius - NES
            gethp=function() return mainmemory.read_u8(0x0020) end,
            getlc=function() return mainmemory.read_u8(0x0020) end,
            maxhp=function() return 1024 end,
        },
    }
end

return script