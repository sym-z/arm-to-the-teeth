## Map Generation
- [x] Data type setup
- [x] Prim's algorithm
- [x] Debug visualizer (Top Down)
- [x] Player Scene and Debug Player Sprite Drawn
- [x] Player Debug Sprite Movement
- [x] Randomized exit spawn
- [x] Randomized landmark/item placement

## First-Person Visualization
- [x] Only render considering the room that you are in *distance 0*
- [x] Render at distance of 1
- [x] Distance of 2
- [x] At furthest distance behind all walls, put a mystery shadow texture to show that that is out of sight.
- [x] Debug Map to Test Rendering
- [ ] Possibly mirror pickups on the right side of the screen. (Might not be as visually pleasing as it sounds)

## Gameplay
- [x] Cells can hold landmarks or items
  - [x] Cells can hold an exit
- [x] Player has an inventory
- [x] Player can pick up teeth
- [ ] When a player picks up teeth, it can be 1 or more teeth in that spot
  - [ ] If player has full teeth, they can leave the remainder on the ground, or it just maxes out their teeth
    - [ ] If they can leave the remainder, then I need to create a tooth atlas when the map is generated like the arms to keep track of tooth drops
- [x] Player can pick up arms
- [ ] Player's spawn point is randomized or has the option to be randomized in `player.gd`, more necessary when UI is in.
- [x] Make arm and tooth pickup optional, this will come when UI starts being programmed
- [x] Enemies Spawn
- [ ] Player vs Enemy Combat (After UI decisions)
  - [ ] Enemies can drop items (Teeth/Arms)
- [ ] Map reveals itself after player moves
  - Could use same debug mini map starting with every sprite hidden, and then when the player moves set the Sprite to visible at that position.
    - Need to leave the option to have the map be fully revealed to keep it applicable for debugging
  - May also remake the debug visualizer as part of the UI and just apply the same tactics used to it
- [ ] Player's arms, teeth, and head all have separate health
  - [x] Arm
  - [x] Teeth
  - [ ] Head
- [x] Assure that a new map can be generated keeping the parts consistent that are needed.
- [x] Derive arm pickup stats from list held in `map.gd`
- [ ] Hunger grows during movement, which can be replenished by eating arms
- [ ] The map's arm drops are randomized
  - [ ] They are also influenced by the floor that the player is on.

## Tools
- [x] Debug mini-map shows landmarks

## Art
- [ ] When creating the final look of the rooms, if there is no room, dont draw lines/pillars that are holding up the walls
- [x] Prototype font

## UI
- [x] Show tooth and arm count
- [ ] Log of what has happened ex: "IT HAS TAKEN 2 DAMAGE TO LEFT ARM"
- [ ] Log window
- [ ] Tooth Indication (Frame = Tooth Count)
  - [x] Temporary label
  - [ ] Prototype Art
  - [ ] Final Art
- [ ] Arm indication (Two separate animations, frames = max condition. Lowered to 0 as damage is taken)
  - [x] Temporary label
  - [ ] Prototype Art
  - [ ] Final Art
- [ ] Head indication (Frame = Head Health)
  - [ ] Temporary label
  - [ ] Prototype Art
  - [ ] Final Art
- [ ] Hunger indication (Stomach animation in between arms. Frame = Hunger level)
  - [ ] Temporary label
  - [ ] Prototype Art
  - [ ] Final Art
- [x] Create separate button theme for buttons that can be disabled or enabled.
  - [ ] Build out theme for disablable buttons
- [ ] Figure out how exits are used
  - [x] Automatic
  - [ ] Dialog window pop-up
- [ ] If there is nothing but arms in the inventory eventually, just make inventory button say 'ARMS' instead.
- [ ] Floor number at top of viewport
- [ ] Better StyleBoxes for inventory and arm items

## Cleanup
- [ ] Remove signal connections that are not being used.
- [ ] Remove old `refresh_viewport()`

## Fixes
- [ ] Farther side wall at distance d2 needs to have a connection of lines from the far center wall at level d2. It also needs to be 1 pixel longer on its left side. This needs to be double-checked in the testing room to see if it is actually visible. The one pixel offset thing seems to be visible, but I have yet to replicate the other issue. It would be nice to take care of though.
  - Will be under the UI's CanvasLayer now.
- [x] Fix issue with side walls that have 2 frames being set to frame 2 and fixing itself by setting to 1. To avoid future undefined behavior the best fix would be to just copy the second frame for each of the side walls that only have 2 frames. 
- [x] May have to eventually manually set the ordering of each of the walls so that the closest walls are always drawn over the farthest, because contents are starting overlap with the walls behind them. I'll probably work on a separate branch to do this.
 - The ordering of layers would go center, left/right, left center/right center, far left/right, far left center/far right center, farther left center/farther right center, farthest left/farthest right side. I'll need to edit `content.gd` to have an export variable for its default ordering that it can go back to when it needs to.