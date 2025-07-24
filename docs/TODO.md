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
- [ ] Possibly mirror pickups on the right side of the screen.

## Gameplay
- [x] Cells can hold landmarks or items
  - [x] Cells can hold an exit
- [x] Player has an inventory
- [x] Player can pick up teeth
- [ ] When a player picks up teeth, it can be 1 or more teeth in that spot
- [x] Player can pick up arms
- [ ] Player's spawn point is randomized or has the option to be randomized in `player.gd`
- [ ] Make arm and tooth pickup optional, this will come when UI starts being programmed
- [ ] Enemies Spawn
- [ ] Player vs Enemy Combat

## Tools
- [x] Debug mini-map shows landmarks

## Art
- [ ] When creating the final look of the rooms, if there is no room, dont draw lines/pillars that are holding up the walls

## Fixes
- [ ] Farther side wall at distance d2 needs to have a connection of lines from the far center wall at level d2. It also needs to be 1 pixel longer on its left side. This needs to be double-checked in the testing room to see if it is actually visible. The one pixel offset thing seems to be visible, but I have yet to replicate the other issue. It would be nice to take care of though.
- [x] Fix issue with side walls that have 2 frames being set to frame 2 and fixing itself by setting to 1. To avoid future undefined behavior the best fix would be to just copy the second frame for each of the side walls that only have 2 frames. 
- [ ] May have to eventually manually set the ordering of each of the walls so that the closest walls are always drawn over the farthest, because contents are starting overlap with the walls behind them. I'll probably work on a separate branch to do this.
 - The ordering of layers would go center, left/right, left center/right center, far left/right, far left center/far right center, farther left center/farther right center, farthest left/farthest right side. I'll need to edit `content.gd` to have an export variable for its default ordering that it can go back to when it needs to.