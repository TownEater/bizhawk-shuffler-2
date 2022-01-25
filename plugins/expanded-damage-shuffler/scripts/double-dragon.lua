local script = {}

function script.get_gamedata()
    return {
        ['double-dragon'] = {-- Double Dragon - NES
            gethp=function() return mainmemory.read_u8(0x03B4) end,
            getlc=function() return mainmemory.read_u8(0x0043) end,
            maxhp=function() return 1024 end,
        },
        ['double-dragon-ii'] = {-- Double Dragon II - NES
            gethp=function() return mainmemory.read_u8(0x041E) end,
            getlc=function() return mainmemory.read_u8(0x041E) end,
            maxhp=function() return 1024 end,
        },
        ['double-dragon-iii'] = {-- Double Dragon III - NES
            gethp=function() return mainmemory.read_u8(0x045D) end,
            getlc=function() return mainmemory.read_u8(0x045D) end,
            maxhp=function() return 1024 end,
        },
    }
end

return script