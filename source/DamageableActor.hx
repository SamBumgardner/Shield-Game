package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Samuel Bumgardner
 */
class DamageableActor extends FlxSprite
{

	private var healthState:FSM;
	private var vulnerable:Bool = true;
	private var hurtTime:Int;
	private var recoveryTime:Int;
	private var injuredColor:Int;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		healthState = new FSM(normState);
	}
	
	private function adjustColor(colorChange:Int):Int
	{
		set_color(color ^ colorChange);
		return color;
	}
	
	private function normTransition():Int
	{
		alpha = 1;
		healthState.activeState = normState;
		vulnerable = true;
		return -1;
	}
	
	private function normState():Void
	{
		return;
	}
	
	private function hurtTransition():Int
	{
		adjustColor(injuredColor);
		healthState.activeState = hurtState;
		healthState.nextTransition = recoveryTransition;
		vulnerable = false;
		return hurtTime;
	}
	
	private function hurtState():Void
	{
		return;
	}
	
	private function recoveryTransition():Int
	{
		adjustColor(injuredColor);
		healthState.activeState = recoveryState;
		healthState.nextTransition = normTransition;
		vulnerable = false;
		return recoveryTime;
	}
	
	private function recoveryState():Void
	{
		if (healthState.stateTimer % 16 < 8)
			set_alpha(0);
		else
			set_alpha(1);
	}
	
	public function damaged(damage:Float):Void
	{
		if (vulnerable == true)
		{
			hurt(damage);
			healthState.transitionStates(hurtTransition);
		}
	}
	
	public override function update(elapsed:Float):Void
	{
		healthState.update();
		super.update(elapsed);
	}
}