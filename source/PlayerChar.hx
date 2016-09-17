package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxG;
/**
 * ...
 * @author Samuel Bumgardner
 */
class PlayerChar extends FlxSprite
{
	public var speed:Float;
	
	public var wallCollidedX:Bool = false;
	public var wallCollidedY:Bool = false;
	
	private var healthState:FSM;
	private var vulnerable:Bool = true;
	private var hurtTime:Int;
	private var recoveryTime:Int;
	private var injuredColor:Int;
	
	public var _up:Bool = false;
	public var _down:Bool = false;
	public var _left:Bool = false;
	public var _right:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		collisonXDrag = false;
		healthState = new FSM(normState);
	}
	
	private function checkInputs():Void{};
	
	private function movement():Void
	{
		checkInputs();
		
		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;
		
		if (_up || _down || _left || _right)
		{
			var mA:Float = 0;
			if (_up)
			{
				mA = -90;
				if (_left)
					mA -= 45;
				else if (_right)
					mA += 45;
				facing = FlxObject.UP;
			}
			else if (_down)
			{
				mA = 90;
				if (_left)
					mA += 45;
				else if (_right)
					mA -= 45;
				facing = FlxObject.DOWN;
			}
			else if (_left){
				mA = 180;
				facing = FlxObject.LEFT;
			}
				
			else if (_right){
				mA = 0;
				facing = FlxObject.RIGHT;
			}
				
			velocity.set(speed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), mA);
		
			//if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
			//{
				//switch (facing)
				//{
					//case FlxObject.LEFT, FlxObject.RIGHT:
						//animation.play("lr");
					//case FlxObject.UP:
						//animation.play("u");
					//case FlxObject.DOWN:
						//animation.play("d");
				//}
			//}
		}
		else
		{
			velocity.set(0, 0);
		}
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
		set_color(injuredColor);
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
		set_color(0xffffff);
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