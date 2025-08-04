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

## Gameplay
- [ ] When a player picks up teeth, it can be 1 or more teeth in that spot
  - [ ] If player has full teeth, they can leave the remainder on the ground, or it just maxes out their teeth
    - [ ] If they can leave the remainder, then I need to create a tooth atlas when the map is generated like the arms to keep track of tooth drops
- [ ] Player's spawn point is randomized or has the option to be randomized in `player.gd`, more necessary when UI is in.
- [ ] The map's arm drops are randomized
  - [ ] They are also influenced by the floor that the player is on.
- [ ] Refine Arm Eating
  - [ ] Check mins and maxes of the stats that it affects for the player
  - [ ] Player can use the same spinning die roll to see how much teeth is lost when eating and possibly how much benefit they gain
- [ ] Refine hunger growth
- [ ] Make eating heal your head a little but improve your hunger a lot
- [ ] Figure out if hunger kills you or hurts your head
- [ ] Multi-Arm Storage
  - [ ] Ability to store extra arms in inventory
  - [ ] Ability to swap between arms
  - [ ] Ability to drop arm on free tile
  - [ ] Ability to swap arms in combat
- [ ] Enemy Movement (STRETCH GOAL)
- [ ] Swapping arm with arm on the ground
  - [ ] Player can see stats of arm on the ground before adding it to inventory
- [ ] Text speed choice in options menu that effects battle speed
- [ ] Content animates in map
### DONE
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
- [ ] Windows have titles and instructions
- [ ] Enemies can drop items (Teeth/Arms)
- [ ] Enemy Animates
  - [x] Prototype
  - [ ] Final
- [ ] Player Animates
  - [x] Prototype
  - [ ] Final
- [ ] Attack dice roller also reveals a label showing the difficulty class for the enemy
- [ ] Higher damage for crit rolls
  - [ ] For enemy
  - [ ] For player
- [ ] A lot more log messages about how much damage is dealt and where.
- [ ] Tune pauses between hits
- [ ] Die rolls faster, or randomizes number.
- [ ] Pause after death before transition
- [ ] Running may damage your arms
- [ ] Enemy animation
  - [ ] Attack
  - [ ] Hurt
  - [ ] Death
- [ ] Player animation
  - [ ] Attack
  - [ ] Hurt
  - [ ] Death
### DONE
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

## Balance
- [ ] More arm spawns with weirder stats.
### DONE

## Tools
### DONE
- [x] Debug mini-map shows landmarks

## Art
- [ ] When creating the final look of the rooms, if there is no room, dont draw lines/pillars that are holding up the walls
- [ ] New font that doesn't have to be 32x32 and can be more vertical than horizontal
- [ ] Arm sprite adjustment
- [ ] Inventory items need better styleboxes
- [x] Add more detailed, thicker lines to the walls. Specifically the inside portion of the left and right walls.
  - [x] D1 left, left side and right right side
  - [x] Could use outline tool in Aseprite!
- [ ] Add in Head animation to stat showcase
- [ ] Add in Arm animation to stat showcase
- [ ] Add in Tooth animation to stat showcase
- [ ] Add in Stomach animation to stat showcase
- [ ] Adjust 3 to resemble an 8 less in `ui_font_1`.
- [ ] Make better vision bounds animation
### DONE
- [x] Prototype font

## UI
- When going back to add animations instead of the labels in the UI, I would really need to just look for whenever the `refresh_temp_labels()` function is called and refresh the animations
- [ ] Inventory Window Title
- [ ] Log Window Title
- [ ] Tooth Indication (Frame = Tooth Count)
  - [x] Temporary label
  - [ ] Prototype Art
  - [ ] Final Art
- [ ] Arm indication (Two separate animations, frames = max condition. Lowered to 0 as damage is taken)
  - [x] Temporary label
  - [ ] Prototype Art
  - [ ] Final Art
- [ ] Head indication (Frame = Head Health)
  - [x] Temporary label
  - [ ] Prototype Art
  - [ ] Final Art
- [ ] Hunger indication (Stomach animation in between arms. Frame = Hunger level)
  - [x] Temporary label
  - [ ] Prototype Art
  - [ ] Final Art
- [x] Create separate button theme for buttons that can be disabled or enabled.
  - [ ] Build out theme for disablable buttons
- [ ] Figure out how exits are used
  - [x] Automatic
  - [ ] Dialog window pop-up
- [ ] If there is nothing but arms in the inventory eventually, just make inventory button say 'ARMS' instead.
- [ ] Better StyleBoxes for inventory and arm items
- [ ] Log window changes stylebox on hover and click
- [ ] Maybe reversing log order and figuring out the scroll feature would be better. It is just so janky though.
- [ ] Make sure that the UI only uses the AT3 palette
  - [ ] Green-white color for stylebox borders
  - [ ] Can use texture stylebox to make more stylized boxes
### DONE
- [x] Show tooth and arm count
- [x] Log of what has happened ex: "IT HAS TAKEN 2 DAMAGE TO LEFT ARM"
- [x] Log window
- [x] Expanded log window on click that is scrollable.
- [x] Floor number at top of viewport

## Cleanup
- [ ] Remove signal connections that are not being used.
- [ ] Remove old `refresh_viewport()`
- [ ] Get rid of "Turn" enum and code in `combat_viewport.gd`
### DONE

## Fixes
- [ ] Farther side wall at distance d2 needs to have a connection of lines from the far center wall at level d2. It also needs to be 1 pixel longer on its left side. This needs to be double-checked in the testing room to see if it is actually visible. The one pixel offset thing seems to be visible, but I have yet to replicate the other issue. It would be nice to take care of though.
  - Will be under the UI's CanvasLayer now.
- [ ] Turn off arrow key input for Context menu
### DONE
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