local plugin = {}

plugin.name = "Expanded Damage Shuffler"
plugin.author = "authorblues, kalimag, towneater, casthemoronicpacifist"
plugin.settings =
{
	-- enable this feature to have health and lives synchronized across games
	--{ name='healthsync', type='boolean', label='Synchronize Health/Lives' },

	{ name='grace', type='number', label='Grace Period (Frames)', default=10 },
}

plugin.description =
[[
	Automatically swaps games any time the player takes damage. Checks hashes of different rom versions, so if you use a version of the rom that isn't recognized, nothing special will happen in that game (no swap on hit).

	Thanks to kalimag for adding support for all the weird games. Extreme0 for adding Megaman ZX & ZX Advent. Thanks to Smight and ZandraVandra for the initial ideas.

	This expanded version was modified by TownEater and CasTheMoronicPacifist to include more games.

	Supports:
	- Mega Man 1-6 NES
	- Mega Man 7 SNES
	- Mega Man 8 PSX
	- Mega Man X 1-3 SNES
	- Mega Man X3 PSX (PAL & NTSC-J)
	- Mega Man X 4-6 PSX
	- Mega Man Xtreme 1 & 2 GBC
	- Rockman & Forte SNES
	- Mega Man I-V GB
	- Mega Man Wily Wars GEN
	- Mega Man Battle Network 1-3 GBA
	- Mega Man Legends/64
	- Mega Man Zero 1-4 GBA
	- Mega Man ZX (USA/PAL/JP)
	- Mega Man ZX Advent (USA/PAL/JP)
	- Rockman & Forte WonderSwan
	- Rockman EXE WS
	- Rockman Battle & Fighters
	- Mega Man Soccer
	- Mega Man Battle & Chase
	- Super Adventure Rockman PSX

	Expanded:
	- Castlevania Nes
	- Castlevania II: Simon's Quest NES
	- Castlvania III NES
	- Super Castlevania IV SNES
	- Castlvania: Dracula X SNES
	- Castlevania: Bloodlines GEN
	- Castlvania: Rondo Of Blood TGFX16 (NTSC-J) 
	- The Legend Of Zelda NES

	Bootlegs:
	- Zook Hero Z (aka Rockman DX6) GBC
	- Zook Hero 2 (aka Rockman X3) GBC
	- Zook Man ZX4 (aka Rockman & Crystal) GBA
	- Thunder Blast Man (aka Rocman X) GBC
	- Rockman 8 GB / Rockman X4 GBC
]]

local prevdata = {}
local NO_MATCH = 'NONE'

local SCRIPT_FOLDER = PLUGINS_FOLDER .. '/expanded-damage-shuffler/scripts'
local HASH_FOLDER = PLUGINS_FOLDER .. '/expanded-damage-shuffler/hashes'

local swap_scheduled = false

local shouldSwap = function() return false end

local function generic_swap(gamemeta)
	return function(data)
		-- if a method is provided and we are not in normal gameplay, don't ever swap
		if gamemeta.gmode and not gamemeta.gmode() then
			return false
		end

		local currhp = gamemeta.gethp()
		local currlc = gamemeta.getlc()

		local maxhp = gamemeta.maxhp()
		local minhp = gamemeta.minhp or -1

		local maxlc = gamemeta.maxlc or 1000

		-- health must be within an acceptable range to count
		-- ON ACCOUNT OF ALL THE GARBAGE VALUES BEING STORED IN THESE ADDRESSES
		if currhp < minhp or currhp > maxhp then
			return false
		end

		-- retrieve previous health and lives before backup
		local prevhp = data.prevhp
		local prevlc = data.prevlc

		data.prevhp = currhp
		data.prevlc = currlc

		-- this delay ensures that when the game ticks away health for the end of a level,
		-- we can catch its purpose and hopefully not swap, since this isnt damage related
		if data.hpcountdown ~= nil and data.hpcountdown > 0 then
			data.hpcountdown = data.hpcountdown - 1
			if data.hpcountdown == 0 and currhp > minhp then
				return true
			end
		end

		-- if the health goes to 0, we will rely on the life count to tell us whether to swap
		if prevhp ~= nil and currhp < prevhp then
			data.hpcountdown = gamemeta.delay or 3
		end

		if currlc > maxlc then
			return false
		end

		if prevlc ~= nil and prevlc > maxlc then
			return false
		end

		-- check to see if the life count went down
		if prevlc ~= nil and currlc < prevlc then
			return true
		end

		return false
	end
end

-- Populate gamedata
local gamedata = {}
for _,filename in ipairs(get_dir_contents(SCRIPT_FOLDER)) do
	if ends_with(filename, '.lua') then
		local pname = filename:sub(1, #filename-4)
		local gamePlugin = require(SCRIPT_FOLDER .. '.' .. pname)
		if gamePlugin ~= nil and gamePlugin.get_gamedata ~= nil then
			local games = gamePlugin.get_gamedata();
			for p,v in pairs(games) do 
				gamedata[p] = v
			end
		end
	end
end

local backupchecks = {
}

local function get_game_tag()
	-- Get a list of hash files
	for _,filename in ipairs(get_dir_contents(HASH_FOLDER)) do
		if ends_with(filename, '.dat') then
			-- try to just match the rom hash first
			local tag = get_tag_from_hash_db(gameinfo.getromhash(), HASH_FOLDER .. '/' .. filename)
			if tag ~= nil and gamedata[tag] ~= nil then return tag end
		end
	end

	

	-- check to see if any of the rom name samples match
	local name = gameinfo.getromname()
	for _,check in pairs(backupchecks) do
		if check.test() then return check.tag end
	end

	return nil
end

function plugin.on_setup(data, settings)
	data.tags = data.tags or {}
end

function plugin.on_game_load(data, settings)
	local tag = data.tags[gameinfo.getromhash()] or get_game_tag()
	data.tags[gameinfo.getromhash()] = tag or NO_MATCH

	-- first time through with a bad match, tag will be nil
	-- can use this to print a debug message only the first time
	if tag ~= nil and tag ~= NO_MATCH then
		log_message('game match: ' .. tag)
		local gamemeta = gamedata[tag]
		local func = gamemeta.func or generic_swap
		shouldSwap = func(gamemeta)
	elseif tag == nil then
		log_message(string.format('unrecognized? %s (%s)',
			gameinfo.getromname(), gameinfo.getromhash()))
	end
end

function plugin.on_frame(data, settings)
	-- run the check method for each individual game
	if swap_scheduled then return end

	local schedule_swap, delay = shouldSwap(prevdata)

	if schedule_swap and frames_since_restart > settings.grace then
		swap_game_delay(delay or 3)
		swap_scheduled = true
	end
end

return plugin
