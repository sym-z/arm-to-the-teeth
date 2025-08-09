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
- Created a new item for the UI, the Mini Map. It is nearly identical to the `debug_visualizer` except that it is invisible 'til the player starts walking around on it.
- Log window in the UI has a better looking `StyleBox`
- Node groups in `ui.tscn` now have `CanvasLayer` parents instead of `Node` parents

## 27 July 2025
- Changed parents for node groups in `ui.tscn` back to `Node` from `CanvasLayer`s because it didn't have much benefit and was causing issues.
- Created `combat_viewport.tscn`, an overlay in the UI scene that creates a JRPG style combat scene overlaying the dungeon viewport
- Removed the *ATTACK* and *RUN* buttons from the UI and put them into the combat viewport
- Made sure that the ordering in the UI scene was capable of allowing the player to access their inventory and the log window while in combat
- Created a new class, `Enemy` that has unique damage, current health, max health, and `SpriteFrames`
- The map now creates the `Enemy` resource and keeps track of them in its `enemy_atlas`
- It is possible for the player to ignore combat for debugging purposes by setting the export variable `ignore_combat` to true in the inspector
- Added die roller scene that can be given an upper and lower limit and a difficulty class, and will fire a signal with the results when the player stops it by clicking. The die can be rolled by clicking it.
- Added a difficulty class property to enemies
- For now, the player always does 1 damage per hit, but I am going to first prompt the player for an arm choice before they attack
- As of right now, I am using a separate die for attacking than I will be for running, just so the signals do not get confused and I can have a better concept of state. I may change that in the future.
- Started the process of changing the turn back over to the enemy.
- Temporarily added more enemies to the floor to aid in debugging.
- Made sure that cell content can only be added if the cell was empty to start.
- Integrated an arm selection window that appears before the die roll
- Player is prompted to select an arm and that amount of damage is applied to the enemy if the roll succeeds
- If the player fails massively, their arm could take damage or be destroyed
- The inventory was refactored to update as combat was going on in the background.
- Player can eat arms in combat, playing into the risk of them losing the arm itself.
- Created a mode for debugging combat where the player starts surrounded by enemies
- Created a flag in `globals.gd` called `verbose_console` that includes all the random print statements around the code.
- I found out that for some reason the dice roller's gui_event will supercede any of the other gui events that are on top of it, i.e. hitting back on the inventory button. To fix this, I made the Combat Viewport be drawn first in the order of the UI but I wasn't able to narrow down exactly why. It is good to keep in mind for the future to not create a die roller on top of anything in the node hierarchy that would need to be accessed
- I have figured out that by changing the `Node` parent of the inventory to `CanvasLayer`s and increasing the ordering it fixes the issue.
- Not sure if I want to change it back fully to all `CanvasLayer` parents, because of the issue at the beginning of this devlog entry, but I can't remember the problems that it was causing that made me want to switch it back. I might try it tomorrow, because for now I am fairly tired.

## 28 July 2025
- Arm management is now disabled when rolling an attacking die in combat.
- New class `Head` that controls player head health
- Head can now be selected in combat to attack with
- Rolling under the DC hurts your head and will eventually deduct teeth
  - I am waiting to implement this because I am not sure if I want to have teeth be a part of the head object's inventory, because that is starting to make sense to me.
- Created a temporary head sprite for head selection.
- Created a temporary head sprite for the combat viewport.
  - Added head sprite to combat viewport.
- UI now gets the head health amount from the player's `Head` object.
- Enemy rolls to attack back
- Made a simple function to create a timer that calls a callback function and destroys itself when its `wait_time` hits 0.
- After the player attacks, there is a slight pause, then the enemy attacks, then a slight pause.
- Player can select a limb to apply damage to
- Damage is applied to limb, and can cause the player to lose their arm.
- After the player makes a limb selection, or if the enemy misses their attack, the cycle begins again and the player is given the option to attack or run.
- Added a function to the Die Roller that allows it to be reset back to its original state.
- Combat needs heaaaavy testing, but it has now made its first loop!
- Combat can correctly determine when the player or enemy dies
- Player can go back to game after killing an enemy.
  - Dungeon viewport removes them from sight
  - Map removes them from `enemy_atlas`
  - Minimap removes their icon
  - Fires signal that the player has "picked up" the item that was in that space, which causes the refresh of the viewport, and the cell to be marked as empty.
- Player can die in combat
  - As of right now, this causes the `testing_level` scene to restart, as if it were the start of play.
  - Eventually I would have the game disable input, cause a pause, then transition to a death scene/game over scene.
- Created a global script based off of one that I created for I.M.P. called `scene_transition.gd`.
  - Handles transitioning scenes in an elegant way that is easy to use from anywhere in the code base.
- Possible directions are correctly gathered before running.
- Created temporary sprites for directions player can run in, and they display accordingly to the possible directions that are available to flee in.
- Set up the signal connection between the directional buttons and wrote pseudocode for how damage should be applied. 
- Took off wait time after player selects what limb they want to damage.

## 2 August 2025
- Created a new branch, "art-revamp" to add in new art assets.
- Importing assets that I had made during a time where I wasn't able to program
  - New assets
    - Head sprite
    - Enemy sprite
    - UI font
    - Stomach sprite
    - Background texture
    - Exit sprite
- Created new wall sprites and imported them to replace the previous wall sprites
  - There will need to be a lot of adjusting in the future for them because some edge lines look funky, but it is a start.
- Created a new scene that governs "Content" at d0, d1, and d2
  - Created so minor adjustments to sprites of items can override all content at that level.

## 3 August 2025
- Added new font and background sprite
- Added a new texture for vision bounds
- Integrated all of the new icons and the font into the existing scenes
  - Still need to add their representation into the stat showcase
- Finished flee behavior
  - Player can now flee in any direction so long as the space is available
  - Fleeing into an enemy space will retrigger combat
  - Fleeing into an exit will automatically transition to the next floor
- Parents of UI elements are now `CanvasLayer`s instead of `Node`s
- Pause timing between moves in combat is now a variable in `combat_viewport.gd` called `pause_time`
- Started experimenting with dimming the color of more distant rooms

## 4 August 2025
- As rooms become more distanced, their colors become dimmer and dimmer
- Contents in further rooms are more dim than rooms that are closer to the player
- Stat showcase on the right side of the viewport now shows animations that change as the player changes the condition of arms, hunger, and their head health.
- Stat showcase includes a simple tooth animation indicator
- Player can lose teeth from damaging their head, and missing a bite
  - Eventually the head will be in charge of tooth management, but for now I am implementing this code until I can work out the responsibility transfer of teeth from player to head on a new branch.
- Labels for:
  - Log full window
  - Mini Map
- Tuned the look of the context menu, made the font size bigger on the buttons and made them fill the container. I am planning on switching all of the context buttons over to one theme soon.

## 5 August 2025
- Combat window has better label
- Better styleboxes for the attack and run buttons
- Combat window uses proper white color for borders of styleboxes
- Context menu border color change
- Stylebox for enemy stats
- Refined the look of the attacking limb selection
  - Better sizing of icons
  - Bigger fonts for labels and buttons
  - Header
  - Consistent border color
- Run direction arrows are now disabled rather than invisible
- Run direction arrows now have a disabled and hover texture
- Run window has a better label 
- Die roller has an instruction label
- Inventory has better labels
- Arm items have cleaner UI
- Inventory has better stylebox
- Inventory buttons use one theme
  - I decided to go against the idea of having differing themes for the disablable buttons because it didn't really make sense to me at this point
- Ownership of teeth management is now delgated to the head
- After dying, log messages are preserved into the next run.
- Multiple teeth can spawn in the same place
  - The map will spawn 1-3 teeth in a spot when marking a tooth cell
  - When attempting to pick up more teeth than the player can hold, the remainder will be left on the ground.
- Enemies now drop loot when killed
  - There are 4 different categories of loot rarity
  - Eventually there are going to be loot stats dependent on floor level and monster type
  - The basic tooth drops have been tested but the other levels still need to be tested before I can mark this task as done. Saving that for tomorrow.
- Made sure that the `enemy_atlas` was being cleared when there was a new level being created, because the function that runs when a new floor was generated was not doing that, which I think was keeping stale references to enemies in the `enemy_atlas` in `map.gd`.

## 6 August 2025
- Loot drops tested and functional
- Clearing `enemy_atlas` seems to have no negative effect
- Head is now in charge of when it is damaged, and deducts health accordingly
- Log messages now have numbers included with them to assist in players understanding the order and how many have happened.
- Got the basics done for a new type of die roller called a "Wheel Roller`
  - Wheel spins and starts at a random frame
  - When a button is pressed to stop the wheel, a function is called based on the frame of the animation
  - As the wheel turns, there is text that matches the effect of what would happen if the wheel were to be stopped at that point
  - Right now, when the functions are called, only print statments happen.
  - Tomorrow I will integrate it into the combat loop.
- Art imported for the Wheel Roller and the clicker thing that collides up against the wheel
- Imported a texture that can be used as a background of a photo that I took in my apartment basement.
- Spent a long time fixing a bug that happened due to erasing a prototype for the wheel roller, and was able to solve it. Further described under `TODO.md` in the section "Keep in Mind". 

## 8 August 2025
- Integrated `wheel_roller.tscn` to take the place of the prototype D20 that was being used. A lot of code can now be taken out of `combat_viewport.gd`.
- Made the area available to land a hit on the `wheel_roller` larger.
- Added in the functionality for arms to be hit when the player flees, still need to test this. 
- I want to look into combining the functions `ui.refresh_temp_labels()` and `ui.refresh_stat_showcase()`
- Added more labels for the UI, namely the Context Menu and the Stats Showcase
- Combined the Stat Showcase and Temp Labels CanvasLayers into having one parent
- Gave the Context Menu its own CanvasLayer parent.
- Log line window now has a header in the UI scene.
- Need to do a lot of testing:
  - All wheel_roller possibilities
  - Arm destroy on flee
  - Both of those affect the UI labels and animations
  - No new UI tweaks affected any mouse input
- When I go to make the game harder based on floor level:
  - Head health and head max health increase by 1 every floor
  - Arm drop base stats increase by floor number
    - Variance will be added so there will still be better and worse arms
  - Enemy base damage and stats increase by floor number
    - Variance will still be added so there will be weaker and stronger enemies
- Adjusted ordering of MiniMap CanvasLayer to be lower than other menus, but needed to make it render after the viewport header container.
- Gave the Minimap its own border

## 9 August 2025
- Testing all of yesterday's work, and merging back into `content-enhancement`
- Adding in some new prototype art for the back of the player's head, and aligning the minimap with the UI. Added some new color's to AT3's palette.
- New keyboard input options added:
  - TAB/I: Open inventory
  - E/SPACE: Pickup