## 19 July 2025
- Created repository, setting up project.
- Implemented Prim's algorithm to generate mazes, created data type for `Cell` and created `world_map`
- Created a spritesheet to use as a debug visualization, and created a visualization of what the world map looks like from a top down perspective.
- Created a debug visualization of the player to show over the debug map to show proper movement in the back end.
- User can move debug player sprite forward, backward and turn

## 20 July 2025
- Created a visualization at distance of 0 of the viewport the player will use.
- Created visualuization at distance of 1 that the player will use. Sprites will be refined, there are some inconsistent line weights, but I'm refining down the logic.

## 21 July 2025
- Completed rendering at a distance of 2 cells
- Added *fog of war* to show view distance cutoff
- Reworked how the walls are rendered so that all cells in the viewable range will be updated regardless of if they are covered up by another wall, so long as the cell is within the bounds of the map.
- Built a testing map to show that I am rendering things correctly.

## 22 July 2025
- Cells can now hold "content"
- Cells can now hold an "exit"
- Player can detect the content of the cell that they are standing on
- Adjustments made to ensure correct ordering of sprites for the content of cells so that their sprites are obscured properly when walls are over them and revealed when they are not.
- Farther side wall at distance d2 needs to have a connection of lines from the far center wall at level d2. It also needs to be 1 pixel longer on its left side. This needs to be double-checked in the testing room to see if it is actually visible. The one pixel offset thing seems to be visible, but I have yet to replicate the other issue. It would be nice to take care of though. This has been also copied over to `TODO.md`.