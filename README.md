# Shield-Game
This is a robot-filled shoot-em-up game created in around 6 weeks by Sam Bumgardner and Alex Mullins, a pair of students from Missouri State University. 

The main purpose of this project was to familiarize myself with [HaxeFlixel](http://www.haxeflixel.com), let us get used to working as a team, and make a (hopefully) fun game at the same time!

## Overview

Guide a mechanic and his robot through an endless horde of futuristic monstrosities! 

The mechanic is small and agile and can repair his robot, but can't defend himself directly. The robot is durable and has the ability to catch and throw back enemy projectiles, but will likely sustain damage in the process.
The only way they can survive is if they work together, complementing each other's strengths and mitigating their weaknesses.

![Shield-Game Screenshot](/docs/Shield-Game_screenshot.png?raw=true)

*Version 1.0* - [Play Here!](http://SamBumgardner.Github.io/Shield-Game)

## Getting Started

To build and run Shield-Game, follow the steps below:

1. Ensure you have [Haxe](http://www.haxe.org/download), [HaxeFlixel](http://www.haxeflixel.com), and [OpenFL](http://www.openfl.org/download/) installed on your computer.
2. Open a command prompt in `\Shield-Game`.
3. Run the command `lime test neko` to build and run the executable.
  * The executable is located in `\Shield-Game\export\windows\neko\bin`.
  * To run in debug mode, run the command `lime test -debug neko`. Then access the debug console with the backquote key.

## Useful Notes

* The game ends if the mechanic runs out of health.
* All controls are keyboard-based. 
 * Use the arrow keys to move the mechanic.
  * If the mechanic touches a repair pack, the robot will be healed by a small amount.
 * Use WASD to move the robot.
 * Hold spacebar to raise the robot's shield—careful, the robot will not be able to move until the shield is fully active.
  * Projectiles that collide with the shield are "caught" by the robot.
  * Release spacebar to drop the shield fire all caught projectiles. 
   * The angle the projectiles move in varies depending on the direction the robot was moving when the shield was released.
* Build up a score multiplier by destroying robots in a short amount of time.
 * The score multiplier will reset to 1 if either player character runs into an enemy.
* Enemy information:
 * Red enemies have 5 health and drop a repair pack when defeated.
 * Purple enemies have 3 health and aim at the mechanic when firing.
  * Destroying these will make the mechanic's job a lot easier.
 * Green enemies have 1 health and fire a lot of projectiles. 
  * Use their attacks to destroy the other enemies.

## Future Developments

This project is pretty rough right now, in terms of both design and code. 
Below are listed some of the changes I'd like to make to this when I have the time to come back to it.

* Reorganize, clean up and document code
* Give the game a difficulty curve instead of a difficulty cliff
* Add a waypoint-based movement system to enemies, which would allow more complex movement patterns to be easily set up
* Build a support system for levels, instead of just an endless mode
* Replace the current health-pickup system with a scrap-gathering and upgrade system
* Add a visual indicator for the multiplier-reset timer
  
## Contribution guidelines

If you're interested in making contributions to this game, please follow the steps outlined below.

* Fork this repository using the button at the top-right part of the page.
* Create a branch off of `develop` with a name that describes what sort of changes you plan to make.
* Make changes/additions/deletions, committing them to your branch as you go. 
 * Aim to make your commits atomic, each dealing with a single subject.
* When finished, come back to this repository and open a pull request from your branch to `master`.
 * See existing pull requests for a general format to follow.
* Your pull request will be reviewed and responded to, and hopefully merged in!

## Contacts

* [@SamBumgardner](https://github.com/SamBumgardner) - Programmer and Designer.
* Alex Mullins - Artist.

Feel free to send me an email at sambumgardner1@gmail.com.