dofile_once("data/scripts/gun/gun_enums.lua")
-- cheatgui loads actions without gun_enums defined, type fields end up nil
if actions and ModIsEnabled( 'cheatgui' ) then
	dofile("data/scripts/gun/gun_actions.lua")
else
	dofile_once("data/scripts/gun/gun_actions.lua")
end
dofile_once("data/scripts/gun/gunaction_generated.lua")

ACTION_DRAW_RELOAD_TIME_INCREASE = 0

current_reload_time = 0
c = {}
shot_effects = {}
discarded = { }
deck = { }
hand = { }
mana = 0.0

local function register_draw( action, c )
	if c == nil then
		return
	end
	GlobalsSetValue( "ASW_SPELL_DRAW_"..action.id, tostring(c.action_draw_many_count) )
	--print( tostring(action.id) .. " " .. tostring(c.action_draw_many_count) )
end

function Reflection_RegisterProjectile( entity_filename )
end

function add_projectile( entity_filename )
end

function add_projectile_trigger_timer( entity_filename, delay_frames, action_draw_count )
	c.action_draw_many_count = action_draw_count
end

function add_projectile_trigger_hit_world( entity_filename, action_draw_count )
	c.action_draw_many_count = action_draw_count
end

function add_projectile_trigger_death( entity_filename, action_draw_count )
	c.action_draw_many_count = action_draw_count
end

function draw_actions( how_many, instant_reload_if_empty )
	c.action_draw_many_count = how_many
end

-- Risk of Items
function add_extra_bullet( count )
end

function check_recursion( data, rec_ )
	return -1
end

function create_shot_state()
	local value = {}
	ConfigGunActionInfo_Init(value)
	return value
end

function asw_setup_spell_draw() 
	reflecting = true
	local asw_EntityLoad = EntityLoad
	EntityLoad = function() end

	for i,action in ipairs(actions) do
		current_reload_time = 0
		c = create_shot_state()
		shot_effects = {recoil_knockback = 0}
		discarded = { }
		deck = { }
		hand = { }
		mana = 0.0
		action.action()
		register_draw( action, c )
	end

	reflecting = false
	EntityLoad = asw_EntityLoad
end

