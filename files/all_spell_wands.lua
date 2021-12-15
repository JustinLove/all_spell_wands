dofile_once("mods/all_spell_wands/files/spell_metadata.lua")

function asw_random_modifier( level )
	return asw_spells_which_draw[Random(1, #asw_spells_which_draw)]
end

function asw_random_terminal( level )
	return asw_spells_terminal[Random(1, #asw_spells_terminal)]
end

asw_setup_spell_draw()

ASW_RANDOM = 1
ASW_VANILLA_MODIFIED = 2
ASW_VANILLA = 3

function asw_pick_wand_type()
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y )

	local random = ModSettingGet("all_spell_wands.random_chance") or 100
	print(tostring(random))
	local modified = ModSettingGet("all_spell_wands.vanilla_modified_chance") or 0
	print(tostring(modified))
	local vanilla = ModSettingGet("all_spell_wands.vanilla_chance") or 0
	print(tostring(vanilla))
	local total = random + modified + vanilla
	local r = Random(0, total)
	if r <= random then
		return ASW_RANDOM
	elseif r <= random + modified then
		return ASW_VANILLA_MODIFIED
	else
		return ASW_VANILLA
	end
end

function asw_get_random_action_with_type( x, y, level, type, i )
	if type == ACTION_TYPE_PROJECTILE then
		return asw_random_terminal( level )
	elseif type == ACTION_TYPE_MODIFIER then
		return asw_random_modifier( level )
	else
		return GetRandomActionWithType( x, y, level, type, i )
	end
end

function asw_wand_add_random_cards( gun, entity_id, level )

	local is_rare = gun["is_rare"]
	local x, y = EntityGetTransform( entity_id )
	if( level == nil ) then level = 1 end
	level = tonumber( level )
	local orig_level = level
	level = level - 1
	local deck_capacity = gun["deck_capacity"]
	local actions_per_round = gun["actions_per_round"]
	local shuffle = gun["shuffle_deck_when_empty"]
	local card_count = Random( 0.51 * deck_capacity, deck_capacity )
	card_count = clamp( card_count, 1, deck_capacity-1 )

	if ( Random( 0, 100 ) < 4 or is_rare == 1 ) then
		asw_wand_add_always_cast( gun, entity_id, level )
	end

	local bullet_card
	card = "LIGHT"

	if shuffle == 1 then
		for i = 1, card_count-1 do
			card = GetRandomAction( x, y, level, i )
			AddGunAction( entity_id, card )
		end
	else
		for i = 1, card_count-1 do
			if Random(1, card_count) <= actions_per_round then
				card = asw_random_terminal( level )
			else
				card = asw_random_modifier( level )
				actions_per_round = actions_per_round + asw_spell_draw[card]
			end
			actions_per_round = actions_per_round - 1
			AddGunAction( entity_id, card )
		end
	end

	card = asw_random_terminal( level )
	AddGunAction( entity_id, card )
end

function asw_wand_add_always_cast( gun, entity_id, level )
	local x, y = EntityGetTransform( entity_id )
	local p = Random(0,100) 
	if ( p < 85 ) then
		card = GetRandomActionWithType( x, y, level+1, ACTION_TYPE_MODIFIER, 666 )
	else 
		card = GetRandomAction( x, y, level, i )
	end
	AddGunActionPermanent( entity_id, card )
end

function asw_print_table( t )
	dofile_once( "data/scripts/lib/utilities.lua" )
	debug_print_table( t )
end
