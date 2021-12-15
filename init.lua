local function test_wands()
	local wands = {
		"data/entities/items/wand_level_01.xml",
		"data/entities/items/wand_level_01_better.xml",
		"data/entities/items/wand_level_02.xml",
		"data/entities/items/wand_level_02_better.xml",
		"data/entities/items/wand_level_03.xml",
		"data/entities/items/wand_level_03_better.xml",
		"data/entities/items/wand_level_04.xml",
		"data/entities/items/wand_level_04_better.xml",
		"data/entities/items/wand_level_05.xml",
		"data/entities/items/wand_level_05_better.xml",
		"data/entities/items/wand_level_06.xml",
		"data/entities/items/wand_level_06_better.xml",
		"data/entities/items/wand_level_10.xml",
		"data/entities/items/wand_unshuffle_01.xml",
		"data/entities/items/wand_unshuffle_02.xml",
		"data/entities/items/wand_unshuffle_03.xml",
		"data/entities/items/wand_unshuffle_04.xml",
		"data/entities/items/wand_unshuffle_05.xml",
		"data/entities/items/wand_unshuffle_06.xml",
		"data/entities/items/wand_unshuffle_10.xml",
	}
	x = 400
	y = -110
	for i, v in ipairs(wands) do
		EntityLoadCameraBound( v, x, y )
		x = x + 10
		y = y + 1
	end
	for i, v in ipairs(wands) do
		EntityLoadCameraBound( v, x, y )
		x = x + 10
	end
end

function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
	test_wands()
end

-- This code runs when all mods' filesystems are registered
ModLuaFileAppend( "data/scripts/gun/procedural/gun_procedural.lua", "mods/all_spell_wands/files/gun_procedural.lua" )
ModLuaFileAppend( "data/scripts/gun/procedural/gun_procedural_better.lua", "mods/all_spell_wands/files/gun_procedural_better.lua" )
