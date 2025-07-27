# Name Ideas
---
- *Arm to the Teeth* or *Armed to the Teeth*

# General Idea
---
- First person dungeon crawler that uses multiple grid based textually represented maps to build it's underlying map
- Turn Based Combat

# Pillars
---
- Body Horror, Decrepit Decay aesthetic
- Turn Based Combat
- Randomly Generated dungeons
- Inventory is your body parts

# Systems and MEchanics
---
- Players use Arms as weapons
- Player has 3 places to put inventory items
	- 2 Arms
		- Arms are found rarely in the level, and are occaisionally dropped by enemies
	- 1 Head
		- The player's HP
		- Holds 32 teeth
			- Teeth are used to consume arms
			- Getting hit takes away health from head, and could knock teeth out
- Arms can be destroyed, eaten, or replaced
- If a player has no arms, they can bite the enemy, but they lose teeth doing so
- Player gets health by consuming arms
	- Teeth can be lost when consuming arms
		- Teeth are abundantly found throughout the level
		- If a player has no teeth, they cannot eat any arms
- When an attack is incoming, a player has a choice of where the damage goes
	- Choosing to damage your head could kill you or make you lose teeth
	- Choosing to damage your arms could make you not be able to do as much damage
	- ROUTING PAIN RECEPTORS
- There can be "Quality" of arms (Stretch goal)
- There can be different types of teeth (Stretch Goal)

## New Ideas
- Hunger forces you to try to kill and eat enemies
  - Forces you to eat your arms
  - Pushes player to combat
- Both the player and enemy need a chance to miss.
- Enemies could teleport to random empty cells by merging with the dungeon of flesh
- I am kinda liking the dungeon of flesh idea

## UI Layout
- UI consists of distinct parts
  - Viewport
    - First person view of the dungeon
  - Log
    - Constantly updating at the bottom of the screen. Ex: "IT PICKS UP 2 TEETH", "IT CANNOT PICK UP THE ARM WHILE IT HAS 2 ARMS"
  - Map
    - Reveals itself as the player walks around
  - Head, Arm, Hunger, and Teeth status
    - Takes up one whole side of the UI
	- Detailed head, arms, stomach and teeth that are damaged and disappear as damage is dealt/ hunger is incurred
  - Context Menu (Possibly instead of hiding and revealing options, it dims and brightens the text)
    - Inventory
	  - Allows player to choose to eat or drop their arms
	  - Stores additional arms and possibly keys later.
	- Pick Up
	  - This may only reveal when the player is standing over an item that can be picked up.
	- Options
	- Quit
	- Attack (Battle Only)
	- Run (Battle Only)
  - Game Status
    - What floor the player is on
	- Possibly playtime and high score
- Notifications can be displayed to the user like in IMP when it is pressing, like choosing where to take damage.

## Enemy Movement (STRETCH GOAL)
- Start out immobile, then enemies can choose a spot to move when the player moves, in cardinal directions, as long as there is not an item blocking them.
  - As the player clears out itmes they are in turn opening the possibilities for greater enemy movement

## Die Rolls
- Could mimick spinning light game from arcade, slot machines, cup and ball game, or just a regular die roll
- STRETCH GOAL: Buffs can change the distribution of numbers in the roll