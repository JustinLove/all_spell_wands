Varia addons and risk of items seem to prevent cheat menus from spawning perks on command
https://discord.com/channels/453998283174576133/626084015996403712/934791282553937990
Kie — Today at 06:46
alright, I think I've gotten the issue resolved 
it seems to be the result of the two mods interacting with another mod I had which randomized all wand generation allowing any spells to end up in a natural wand (all spell wands), which was then interfering with cheatgui and cheat menu's ability to spawn perks
having only either the random wand gen mod enabled with cheatgui or risk/varia with cheatgui works just fine
there may or may not be some more layers to this issue but to be fully honest I'm happy doing away with just one mod. Thank you for the help


## Varia

- Special wands have a bit of code with that reference undefiend values action_count and gun_action
- Actions use GetUpdatedEntityID which can return garbage when reflecting
- Random modifier should check that the table has entries before calling one
## Risk of Items

- uses extra gun method add_extra_bullet - fixable

## cheatgui

- should load gun_enums befor gun_actions to avoid nil spell types - workaround
