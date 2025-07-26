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

## 23 July 2025
- Cells can now hold "arms" and "teeth"
- The map now keeps track of empty cells to improve performance when looking for places to set down items
- The cells surrounding the player are marked as spawning cells, to prevent being surrounded by enemies when the player spawns
- Temporary art imported for cells and teeth
- Dungeon exit now randomly spawns
- Fixed possible future undefined behavior by making sure all side walls have 3 frames of animation
- Teeth and arms can now be picked up to a certain maximum, and the viewport is refreshed to show that it has been picked up
- Pickups happen automatically, but in the future when the UI is being programmed, I want to make it optional.
- Fixed weird ordering problem by setting the Far Right and Far Left walls in d2 to have a higher ordering priority, because they were unintentionally covering up certain items as shown in `error_tracking/rendering_issue.png`. This may end up looking weird with the red line "pillars" that hold up each cube, but I dont think it will matter later because I can always just not draw those lines when there is no wall.
- May have to eventually manually set the ordering of each of the walls so that the closest walls are always drawn over the farthest, because contents are starting overlap with the walls behind them. I'll probably work on a separate branch to do this.
  - The ordering of layers would go center, left/right, left center/right center, far left/right, far left center/far right center, farther left center/farther right center, farthest left/farthest right side. I'll need to edit `content.gd` to have an export variable for its default ordering that it can go back to when it needs to.
  - An easy way to do this would be to start on the farthest walls and increase the ordering starting by 1 from 0. The far left and far right walls will need to be adjusted because of the fix mentioned previously.
- Debug map now shows icons for the different types of cells and they are hidden when the player picks them up.
- Reworked the layering so now specific walls closer to the player have higher priority of layering. Makes positioning sprites for the content of cells easier.
  - D0, D1 and D2 all have base ordering that the child nodes build upon. This is detailed in `REFERENCE.md`

## 24 July 2025
- Enemy type cell drawn
- Enemy type cell shows in mini-map
- Enemy type cell spawns randomly and is shown to and detected by the player
- Sketched up reference of sizing for UI
- Adjusted placement of icons in viewport
- Created font to be used for prototyping UI
- Came up with an idea of what the UI will look like, and what picking up items and attacking an enemy may look like as well.

## 25 July 2025
- Added context menu to border around viewport
- Added UI bordering
- Teeth and Arms can be picked up using context menu
- Arms are unique, and picking them up adds them to your inventory and equips them
  - Not sure if I want the player to hold multiple arms or be able to drop/swap arms yet. I'll work that out after combat and into balancing systems.
- Map keeps track of unique arm drops with its `arm_atlas`
- Map can be regenerated using the `G` key, and is automatically regenerated when the player touches an exit. This increases a floor counter in `Globals.gd`
- UI displays teeth and arm count
- Inventory can be revealed and hidden using context menu
- Inventory displays the arms that the player picks up, which includes their strength, condition, and if they are equipped
- Started the base work for hunger and head health
- UI is now on top of viewport and has the center transparent
- UI displays hunger and head health

## 26 July 2025
- Player can eat their arms
  - Player can only eat their arms if they have at least 1 tooth
  - Player loses hunger, teeth, and the arm's condition when arms are eaten, and gains head health
  - Eventually I want to make it a gamble whether or not teeth are even lost when arms are eaten, or multiple teeth can be lost
  - Fully eating an arm removes it from the player's inventory, and from the inventory window
- Hunger grows as the player moves
  - Transitions the player through states of hunger which emit signals when they switch to a new state
  - Eating arms can lower the player through a state
- When going back to add animations instead of the labels in the UI, I would really need to just look for whenever the `refresh_temp_labels()` function is called and refresh the animations
- Added in a global script, `log.gd` which keeps track of messages sent to it and emits a signal when a new message is added.
- Added a log window to the UI which displays the most recent log message.
- Log line window can be clicked to reveal all of the log messages that have been sent since the start, and scroll through them
  - It is impossible to have the inventory and log window open at the same time
- The viewport has a header label that keeps track of what floor the player is on.