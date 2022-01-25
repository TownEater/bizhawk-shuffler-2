local script = {}

function script.get_gamedata()
    return {
        ['castlevania'] = { -- Castlevania - NES
            gethp=function() return mainmemory.read_u8(0x0045) end,
            getlc=function() return mainmemory.read_u8(0x002A) end,
            maxhp=function() return 64 end,
        },
        ['castlevania-2'] = { -- Castlevania 2 - NES
            gethp=function() return mainmemory.read_u8(0x0080) end,
            getlc=function() return mainmemory.read_u8(0x0031) end,
            maxhp=function() return 256 end,
        },
        ['castlevania-3'] = { -- Castlevania 3 - NES
            gethp=function() return mainmemory.read_u8(0x3C) end,
            getlc=function() return mainmemory.read_u8(0x35) end,
            maxhp=function() return 1024 end,
        },
        ['castlevania-4'] = { -- Super Castlevania 4 - SNES
            gethp=function() return mainmemory.read_u8(0x0013F4) end,
            getlc=function() return mainmemory.read_u8(0x00007C) end,
            maxhp=function() return 1024 end,
        },
        ['castlevania-dracx'] = { -- Castlevania Dracula X - SNES
            gethp=function() return mainmemory.read_u8(0x0000A8) end,
            getlc=function() return mainmemory.read_u8(0x00009E) end,
            maxhp=function() return 1024 end,
        },
        ['castlevania-bloodlines'] = { -- Castlevania Bloodlines - Mega Drive
            gethp=function() return mainmemory.read_u16_be(0x9C10) end,
            getlc=function() return mainmemory.read_u16_be(0xFB2E) end,
            maxhp=function() return 1024 end,
            maxlc=1000,
        },
        ['dracula-x-rondo-of-blood'] = { -- Castlevania Rondo Of Blood - Turbografx 16
            gethp=function() return mainmemory.read_u8(0x0098) end,
            getlc=function() return mainmemory.read_u8(0x1616) end,
            maxhp=function() return 1024 end,
        },
    }
end

return script