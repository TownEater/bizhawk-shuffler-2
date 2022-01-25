local script = {}

function script.get_gamedata()
    return {
        ['loz-nes'] = { -- Legend of Zelda, The - NES
            gethp=function()
                local containers = (bit.band(mainmemory.read_u8(0x066F), 0x0F) * 2)
                local partial = mainmemory.read_u8(0x0670)
                local partialAmount = 0
                if partial > 0xF0 then -- full heart
                    partialAmount = 2
                elseif partial > 0 then -- partial heart
                    partialAmount = 1
                else
                    partialAmount = 0
                end
                return (containers + partialAmount)
            end,
            getlc=function()
                -- We lie, simulate a lives system
                local containers = (bit.band(mainmemory.read_u8(0x066F), 0x0F) * 2)
                local partial = mainmemory.read_u8(0x0670)
                local partialAmount = 0
                if partial > 0xF0 then -- full heart
                    partialAmount = 2
                elseif partial > 0 then -- partial heart
                    partialAmount = 1
                else
                    partialAmount = 0
                end
                local health = containers + partialAmount
    
                -- Check if dead
                if health > 0 then 
                    return 2
                else
                    return 1
                end
            end,
            maxhp=function() return (bit.rshift(bit.band(mainmemory.read_u8(0x066F), 0xF0), 4) * 2) + 2 end,
        },
        ['zelda-ii'] = { -- Zelda II: Adventure Of Link - NES
            gethp=function() return mainmemory.read_u8(0x0565) end,
            getlc=function() return mainmemory.read_u8(0x0700) end,
            maxhp=function() return 1024 end,
        },
        ['zelda-lttp'] = { -- The Legend of Zelda: A Link to the Past - SNES
            gethp=function() return mainmemory.read_u8(0x00F36D) end,
            getlc=function()
                local health = mainmemory.read_u8(0x00F36D)
    
                -- Check if dead
                if health > 0 then
                    return 2
                else
                    return 1
                end
            end,
            maxhp=function() return 1024 end,
        }
    }
end

return script