package;

import flixel.FlxGame;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		
		var transition = new TransitionData(FADE, 0xffffffff);
		FlxTransitionableState.defaultTransIn = transition;
		FlxTransitionableState.defaultTransOut = transition;
		
		addChild(new FlxGame(1280, 960, PlayState));
	}
}