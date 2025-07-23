## Map Generation
- [x] Data type setup
- [x] Prim's algorithm
- [x] Debug visualizer (Top Down)
- [x] Player Scene and Debug Player Sprite Drawn
- [x] Player Debug Sprite Movement
- [x] Randomized exit spawn
- [ ] Randomized landmark/item placement (1)

## First-Person Visualization
- [x] Only render considering the room that you are in *distance 0*
- [x] Render at distance of 1
- [x] Distance of 2
- [x] At furthest distance behind all walls, put a mystery shadow texture to show that that is out of sight.
- [x] Debug Map to Test Rendering

## Gameplay
- [x] Cells can hold landmarks or items
  - [x] Cells can hold an exit
- [x] Player has an inventory
- [ ] Player can pick up teeth (2)
- [ ] When a player picks up teeth, it can be 1 or more teeth in that spot (5)
- [ ] Player can pick up arms (3)
- [ ] Enemies Spawn
- [ ] Player vs Enemy Combat

## Tools
- [ ] Debug mini-map shows landmarks (4)

## Fixes
- [ ] Farther side wall at distance d2 needs to have a connection of lines from the far center wall at level d2. It also needs to be 1 pixel longer on its left side. This needs to be double-checked in the testing room to see if it is actually visible. The one pixel offset thing seems to be visible, but I have yet to replicate the other issue. It would be nice to take care of though.
- [x] Fix issue with side walls that have 2 frames being set to frame 2 and fixing itself by setting to 1. To avoid future undefined behavior the best fix would be to just copy the second frame for each of the side walls that only have 2 frames. 