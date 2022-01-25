local script = {}

function script.get_gamedata()
    return {
        ['tetris-plus'] = { -- Tetris Plus - PSX
            func=function()
                return function(data)
                    local gameoverFlag = mainmemory.read_u16_be(0x013BE0) == 257
                    if gameoverFlag == false then gameoverFlag = (mainmemory.read_u16_be(0x0C4F00) > 0 and mainmemory.read_u16_be(0x0C4F00) < 10) end

                    local lastFlag = data.tp_gameover;
                    data.tp_gameover = gameoverFlag;

                    if lastFlag ~= nill and lastFlag == false and gameoverFlag == true then
                        return true
                    end

                    return false
                end
            end
        },
    }
end

return script