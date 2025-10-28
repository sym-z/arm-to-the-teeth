## Map Generation
### DONE
- [x] Data type setup
- [x] Prim's algorithm
- [x] Debug visualizer (Top Down)
- [x] Player Scene and Debug Player Sprite Drawn
- [x] Player Debug Sprite Movement
- [x] Randomized exit spawn
- [x] Randomized landmark/item placement

## First-Person Visualization
- [ ] Possibly mirror pickups on the right side of the screen. (Might not be as visually pleasing as it sounds)
### DONE
- [x] Only render considering the room that you are in *distance 0*
- [x] Render at distance of 1
- [x] Distance of 2
- [x] At furthest distance behind all walls, put a mystery shadow texture to show that that is out of sight.
- [x] Debug Map to Test Rendering

## Outside of Gameplay
- [ ] High score menu
### DONE
- [x] Main Menu
  - Words for Arm and Teeth are made from arms and teeth.
- [x] How to Play
- [x] Death Screen
- [x] Track highest floor achieved

## Gameplay
- [ ] Player's spawn point is randomized or has the option to be randomized in `player.gd`, more necessary when UI is in.
- [ ] Refine Arm Eating
  - [x] Check mins and maxes of the stats that it affects for the player
  - [ ] Player can play a minigame to see how much teeth is lost when eating and possibly how much benefit they gain
- [ ] Multi-Arm Storage (STRETCH GOAL)
  - [ ] Ability to store extra arms in inventory
  - [ ] Ability to swap between arms
  - [ ] Ability to drop arm on free tile
  - [ ] Ability to swap arms in combat
- [ ] Enemy Movement (STRETCH GOAL)
  - Basic idea: Enemy decides movement immediately, then executes when player moves, then decides new movement based on new information.
  - Enemies can't move on top of eachother.
- [ ] Swapping arm with arm on the ground
  - [ ] Player can see stats of arm on the ground before adding it to inventory
- [ ] Anything that removes teeth for the most part should have a chance of not doing so. Make a `roll_for_teeth_lost()` function in head and implement it.
- [ ] Future die rollers can be managed using a `Dictionary[int, Callable]` to run functions based off of the frame it lands on.
- [ ] On new floor, decide on head upgrade, or arm upgrade? (STRETCH GOAL)
  - Keep in mind if you do this that the player's DC now needs to be adjusted because a standard subtraction of `Globals.curr_floor` is happening to the player's health when the DC is being calculated, so non-head upgrades will result in negative impact of the player's DC. 
  - Try to make the enemy rolls go from 1 - player.max_health *4 and set the DC to player.max_health /4
- [ ] Different arms/ enemies have different wheels/die roller games (STRETCH GOAL)
  - Customizations can be done by overlaying new sectons onto the wheel roller, and manually changing the dictionary in the back end.
- [ ] New attack limb choice minigame that is a reaction based block
- [ ] Content animates in dungeon viewport
  - [x] Shader
  - [ ] Animation
### DONE
- [x] Player has vision of 1 on minimap
- [x] `Node2D`s can have shaders, could I set the parents of the walls to apply dimming?
- [x] Chest / lock and key puzzle
- [x] Text speed choice in options menu that effects battle speed
- [x] The map's arm drops are randomized
  - [x] They are also influenced by the floor that the player is on.
- [x] Refine hunger growth
- [x] Make eating heal your head a little but improve your hunger a lot
- [x] Figure out if hunger kills you or hurts your head
  - If hunger removes head health, don't use `head.damage()` because it shouldn't cause teeth to be lost.
- [x] SPACE to pick up
  - Remember to have `ui.gd` check if the button is disabled first
- [x] TAB for inventory
  - Remember to have `ui.gd` check if the button is disabled first
- [x] When a player picks up teeth, there can be 1 or more teeth in that spot
  - [x] If player has full teeth, they can leave the remainder on the ground, or it just maxes out their teeth
    - [x] If they can leave the remainder, then I need to create a tooth atlas when the map is generated like the arms to keep track of tooth drops
- [x] Player's arms, teeth, and head all have separate health
  - [x] Arm
  - [x] Teeth
  - [x] Head
- [x] Assure that a new map can be generated keeping the parts consistent that are needed.
- [x] Derive arm pickup stats from list held in `map.gd`
- [x] Hunger grows during movement, which can be replenished by eating arms
- [x] Player can eat their arms
- [x] Map reveals itself after player moves
  - Could use same debug mini map starting with every sprite hidden, and then when the player moves set the Sprite to visible at that position.
    - Need to leave the option to have the map be fully revealed to keep it applicable for debugging
  - May also remake the debug visualizer as part of the UI and just apply the same tactics used to it
- [x] Make arm and tooth pickup optional, this will come when UI starts being programmed
- [x] Player can pick up arms
- [x] Cells can hold landmarks or items
  - [x] Cells can hold an exit
- [x] Player has an inventory
- [x] Player can pick up teeth
- [x] Enemies Spawn

## Player vs Enemy Combat 
- [ ] Higher damage for crit rolls
  - [ ] For enemy
  - [x] For player
- [ ] A lot more log messages about how much damage is dealt and where.
- [ ] More enemy types
  - [ ] Loot drops are dependent on monster type
- [ ] Multi-stage block
### DONE
- [x] Cancel running / attacking choice?
- [x] Enemy animates
  - [x] Prototype
  - [x] Final
- [x] Enemy animation
  - [x] Attack
  - [x] Hurt
  - [x] Death
- [x] Player animation
  - [x] Attack
  - [x] Hurt
  - [ ] Death (NOT APPLICABLE)
- [x] Tune pauses between hits
- [x] Pause after death before transition / eye close animation
- [x] Player Animates
  - [x] Prototype
  - [x] Final
- [x] Make the enemy rolls go from 1 - player.max_health *4 and set the DC to player.max_health for runaway damage and enemy roll calculations in combat.
- [x] Monster stats are depedent on floor level
- [x] Loot drops are dependent on floor level
- [x] Running may damage your arms
- [ ] Attack dice roller also reveals a label showing the difficulty class for the enemy (NOT APPLICABLE)
- [ ] Die rolls faster, or randomizes number. (NOT APPLICABLE)
- [x] Windows have titles and instructions
- [x] Enemies can drop items (Teeth/Arms)
- [x] Battle can end
  - [x] Enemy Death
  - [x] Player Death
  - [x] Player Flees
- [x] Add player head to list of arms to select in arm selection screen
- [x] When combat starts, everything but the enemy goes black
- [x] Enemy attacks back
- [x] Player chooses where the damage hits and suffers consequences
- [x] Consistent cyclical battle
- [x] Combat dice roll can involve the player clicking to stop the spinning dice
- [x] Combat scene show enemy health and damage
- [x] Player chooses what arm to attack with

## Audio
- [ ] Tune Volume
- [ ] UI Select
- [ ] Dungeon ambience
- [ ] Enemy attack
- [ ] Battle ambience
- [ ] Death screen
- [ ] Hunger Satisfied
- [ ] Player miss
### DONE
- [x] Wheel
  - [x] Miss
  - [x] Crit
  - [x] L Hit
  - [x] H Hit
  - [x] L Whiff
  - [x] M Whiff
  - [x] H Whiff
- [x] Finger
  - [x] Punish
  - [x] Fail
  - [x] Block
- [x] Hurt noise for:
  - [x] Hunger damage
- [x] Hunger State Transition
- [x] Arm Pickup
- [x] Player attack
  - [x] Player Crit
  - [x] Player Whiff
## Balance
- [ ] More arm spawns with weirder stats.
### DONE

## Tools
### DONE
- [x] Debug mini-map shows landmarks

## Art
- [ ] When creating the final look of the rooms, if there is no room, dont draw lines/pillars that are holding up the walls
- [ ] Adjust 3 to resemble an 8 less in `ui_font_1`.
- [ ] Shaders
- [ ] More lighting
- [ ] Tunnel vision overlay
- [ ] Tune jiggle shader to use uniforms that are randomly set to have variance between content movement
- [ ] Textures for floor and wall are decided for the whole floor when a new floor is loaded, and it will be like a separate palette is used.
### DONE
- [x] Inventory items need better styleboxes
- [x] Tooth chomp scene transition
- [x] Enemy idle animation
- [x] Start up animation overlay of an eye opening up from first person view
- [x] Gate transition animation
- [x] Arm sprite reduction to fit `dungeon_viewport` more cleanly. (112x178)
- [x] Make better vision bounds animation
- [x] Jaw-like tooth stat showcase animation
- [x] Tooth icon for hud
- [x] New font that doesn't have to be 32x32 and can be more vertical than horizontal
- [x] Add in Head animation to stat showcase
- [x] Add in Arm animation to stat showcase
- [x] Add in Tooth animation to stat showcase
- [x] Add in Stomach animation to stat showcase
- [x] Prototype font
- [x] Add more detailed, thicker lines to the walls. Specifically the inside portion of the left and right walls.
  - [x] D1 left, left side and right right side
  - [x] Could use outline tool in Aseprite!

## UI
- [ ] If there is nothing but arms in the inventory eventually, just make inventory button say 'ARMS' instead.
- [ ] Maybe reversing log order and figuring out the scroll feature would be better. It is just so janky though.
- [ ] Make sure that the UI only uses the AT3 palette
  - [x] Green-white color for stylebox borders
  - [ ] Can use texture stylebox to make more stylized boxes
- [ ] Enemy is named in the combat window
- [ ] (STRETCH GOAL) Log messages have a timestamp
- [ ] Convert all buttons to use red hover stylebox 
- [ ] Occasional blinking animation
- [ ] Tunnel vision overlay
- [ ] Overlays could be done to mix eating and physical damage to arms
### DONE
- [x] Better StyleBoxes for inventory and arm items
- [x] Player has vision of 1 on minimap
- [x] Shader that moves items that are content
- [x] Arms show `condition`/`max_condition` in stat_showcase instead of arm count
- [x] Figure out how exits are used
  - [x] Automatic
  - [x] Dialog window pop-up
- [x] Panel container surrounds viewport instead of built in border
  - Remember to ignore mouse input
- [ ] "Sunken In" slots where the context menu, stat showcase, minimap, log and header go. (NOT APPLICABLE, NEW METHOD USED)
- [x] Arm indication (Two separate animations, frames = max condition. Lowered to 0 as damage is taken)
  - [x] Temporary label
  - [x] Prototype Art
  - [x] Final Art
- [x] Head indication (Frame = Head Health)
  - [x] Temporary label
  - [x] Prototype Art
  - [x] Final Art
- [x] Hunger indication (Stomach animation in between arms. Frame = Hunger level)
  - [x] Temporary label
  - [x] Prototype Art
  - [x] Final Art
- [x] Tooth Indication (Frame = Tooth Count)
  - [x] Temporary label
  - [x] Prototype Art
  - [x] Final Art
- [x] Head ui shows (`health`/`max_health`)
- [x] First log message pushed is the default text for the log line window.
- [x] Border around mini-map
  - 320 x 320px is the max size for map
- [x] Log window changes stylebox on hover and click
  - [x] Log window changes to hover stylebox for a certain amount of time when a log message goes through
  - A little difficult, requires styleboxes to be switched in and out with code, and timers to be made for the log update
- [x] Log line window label?
- [x] Stat showcase labelled with "STATS"
- [x] Log messages have a number associated with them
- [x] Context menu buttons should have one theme because it shouldn't matter what can and can't be disabled if I am disabling random buttons at random times.
- [x] Create separate button theme for buttons that can be disabled or enabled.
- [x] Inventory Window Title
- [x] Log Window Title
- [x] Show tooth and arm count
- [x] Log of what has happened ex: "IT HAS TAKEN 2 DAMAGE TO LEFT ARM"
- [x] Log window
- [x] Expanded log window on click that is scrollable.
- [x] Floor number at top of viewport

## Cleanup
- [ ] Remove signal connections that are not being used.
- [ ] Remove old `refresh_viewport()`
- [ ] Get rid of "Turn" enum and code in `combat_viewport.gd`
- [ ] Change functions `damage_head` and `damage_arm` to be more specific, showing that this is taking place during the damage limb phase of combat
- [ ] Clean up TODO's in `combat_viewport.gd`
- [ ] Get rid of all console warnings.
### DONE

## Fixes
- [ ] Farther side wall at distance d2 needs to have a connection of lines from the far center wall at level d2. It also needs to be 1 pixel longer on its left side. This needs to be double-checked in the testing room to see if it is actually visible. The one pixel offset thing seems to be visible, but I have yet to replicate the other issue. It would be nice to take care of though.
  - Will be under the UI's CanvasLayer now.
- [ ] Prevent negative values for appearing for
  - [ ] Teeth
  - [ ] Arm condition
  - [ ] Head health
- [ ] Add padding to font and re-export
- [x] Fleeing combat no longer re enters combat
### DONE
- [x] Turn off arrow key input for Context menu
- [x] Head should be in charge of tooth count
- [x] Try to make the `CanvasLayer` parent thing work in the UI scene.
- [x] Fix issue with side walls that have 2 frames being set to frame 2 and fixing itself by setting to 1. To avoid future undefined behavior the best fix would be to just copy the second frame for each of the side walls that only have 2 frames. 
- [x] May have to eventually manually set the ordering of each of the walls so that the closest walls are always drawn over the farthest, because contents are starting overlap with the walls behind them. I'll probably work on a separate branch to do this.
  - The ordering of layers would go center, left/right, left center/right center, far left/right, far left center/far right center, farther left center/farther right center, farthest left/farthest right side. I'll need to edit `content.gd` to have an export variable for its default ordering that it can go back to when it needs to.

## Optimization
- [ ] Some Objects are being spawned, ~5 when the map is regenerated. Where and why?
### DONE
- [x] Make "Content" at each distance its own unique scene.

## Test
### DONE
- [x] Make sure that the cell is added to empty cells after killing an enemy.
- [x] What happens if you make the map 15x15?
  - Seems to be fine, but I'd keep testing this in the future.

## Keep in Mind
- The `arm_item` is stopping GUI events
- If I ever want to do swapping, remember to trigger a refresh to the inventory and the arm_selection screen.
- Die rollers will supercede any gui_events underneath them in the node hierarchy for some reason. Keep this in mind when looking to add die rollers to the game in the future.
- Adjusted d1 far left and far right wall to be 5 pixels lower because the added pixels to the top and bottom of certain adjacent sprites threw off its positioning
- When going back to add animations instead of the labels in the UI, I would really need to just look for whenever the `refresh_temp_labels()` function is called and refresh the animations
- Got a weird error about uid "dqrdhjjdlmsmt", keep an eye out. It happened when I was adding children to the wheel roller
  - I was able to solve it by deleting the reference in `.godot/editor/quick_open_dialog_cache.cfg` and put a screenshot of the uid I deleted in `dev_screenshots/error_tracking/uid_removal.png`
  - I found out about why this problem occured and where to go to go about solving it by finding a GitHub Issue that was created about it at this link: https://github.com/godotengine/godot/issues/104961

## To Apply Before App Submission:
- [x] New map configuration
  - [x] Overlay that doesn't allow movement
  - [x] Change map color
- [ ] Purpose
  - [ ] Why is the player there? What is their motivation?
    - [ ] It will be a creation, created from the living biomass walls of the dungeon and fighting failed creations on Its journey to ascend to a chosen organism.
- [x] Audio Ambience
  - [x] Creepy, Groaning unsettling atmosphere
- [ ] Texture Overhaul
  - [x] Make new textures
- [ ] New arm configuration
  - [x] Click to eat
  - [ ] Remake eating texture
- [x] New pickup mechanic implementation
  - [x] Walking over items automatically picks them up
- [ ] Stat display
  - [ ] Clicking on head will show current stats in a numerical window that must be closed to move around
- [ ] Enemies are "failed creations"
- [ ] Vision bounds remake
- [ ] Wheel sprite remake
  - [ ] Teeth rotating in a mouth, like viewing the wheel from a side angle. Only 5 or so options are visible at any one time.
- [x] Moving Minimizes map
- [ ] Jiggle shader for menu items
- [ ] Adjust shadow sizing for menu items
- [ ] Adjust contrast of menu items
  - [x] AUTO PICKUP
    - [x] MAKE TWEEN MOVE TO PROPER POSITIONS
  - [x] HIDE MAP ON MOVE
- [ ] Click head shows extended stat menu. Maybe.
- [x] Randomized groan and sfx system on top of ambience
- [x] Set up audio bus for all sound effects
- [ ] Combat ambience
  - [ ] Ambient system mutes when you get into combat
- [ ] Make tween look more choppy for size
- [ ] Eye closes when map closes
- [ ] Re-mix Ambient Base to be weirder
- [x] Add some randomization to the pitch of the groans
- [ ] Possibly use an exported array for the different sting sounds

###  Goals for session after 10/22:
- [ ] Replace Wheel Roller
  - Make basic prototype sprites
  - Implement gameplay
  - Replace sprites
  - Make the next and previous tooth set automatically based on array.
  - put a ton more teeth in
- [ ] Groan Effects
- [x] Eye Shuts when map closes
- [ ] Some way of letting the player choose the correct arm to eat, they should know an arm's power
  - Meters, COD Medal Type framing
- [ ] Better eat icon
- [x] Trigger attempt to pick up even when arms are full
- [ ] Maybe adjust side wall color and design
  - Emphasize depth of fetuses and show verticality
- [ ] Hunger shows meter
- [ ] Number scarce stat menu
- [ ] Change stings to be groans so you can have multiple sting types
- [ ] Multi-Block