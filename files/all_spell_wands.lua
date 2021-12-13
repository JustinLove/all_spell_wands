function asw_wand_add_random_cards( gun, entity_id, level )
	local is_rare = gun["is_rare"]
	local x, y = EntityGetTransform( entity_id )
	if( level == nil ) then level = 1 end
	level = tonumber( level )
	local orig_level = level
	level = level - 1
	local deck_capacity = gun["deck_capacity"]
	local actions_per_round = gun["actions_per_round"]
	local card_count = Random( 0.51 * deck_capacity, deck_capacity )
	card_count = clamp( card_count, 1, deck_capacity-1 )

	if ( Random( 0, 100 ) < 4 or is_rare == 1 ) then
		asw_wand_add_always_cast( gun, entity_id, level )
	end

	local bullet_card
	--card = GetRandomActionWithType( x, y, level, ACTION_TYPE_PROJECTILE )
	card = "LIGHT"
	for i = 1, card_count do
		card = GetRandomAction( x, y, level, i )
		AddGunAction( entity_id, card )
	end
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
