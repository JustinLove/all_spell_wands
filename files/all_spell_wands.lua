function asw_spell_draw( card )
	return tonumber(GlobalsGetValue( "ASW_SPELL_DRAW_"..card, "0" ))
end

function asw_random_modifier( x, y, level, i )
	local crazy = 0
	local card
	while crazy < 100 do
		crazy = crazy + 1
		card = GetRandomAction( x, y, level, i + crazy*71 )
		if asw_spell_draw( card ) > 0 then
			return card
		end
	end
	print("we went crazy")
	return card
end

function asw_random_terminal( x, y, level, i )
	local crazy = 0
	local card
	while crazy < 100 do
		crazy = crazy + 1
		card = GetRandomAction( x, y, level, i + crazy*10 )
		if asw_spell_draw( card ) < 1 then
			return card
		end
	end
	print("we went crazy")
	return card
end

ASW_RANDOM = 1
ASW_VANILLA_MODIFIED = 2
ASW_VANILLA = 3

function asw_pick_wand_type()
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y )

	local random = ModSettingGet("all_spell_wands.random_chance") or 100
	local modified = ModSettingGet("all_spell_wands.vanilla_modified_chance") or 0
	local vanilla = ModSettingGet("all_spell_wands.vanilla_chance") or 0
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
		return asw_random_terminal( x, y, level, i )
	elseif type == ACTION_TYPE_MODIFIER then
		return asw_random_modifier( x, y, level, i )
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
				card = asw_random_terminal( x, y, level, i )
			else
				card = asw_random_modifier( x, y, level, i )
				actions_per_round = actions_per_round + asw_spell_draw( card )
			end
			actions_per_round = actions_per_round - 1
			AddGunAction( entity_id, card )
		end
	end

	card = asw_random_terminal( x, y, level, card_count )
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
