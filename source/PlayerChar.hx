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
class PlayerChar extends DamageableActor
{
	public var speed:Float;
	
	public var wallCollidedX:Bool = false;
	public var wallCollidedY:Bool = false;
	
	public var force:Int;

	public var _up:Bool = false;
	public var _down:Bool = false;
	public var _left:Bool = false;
	public var _right:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		collisonXDrag = false;
	}
	
	private function checkInputs():Void{};
	
	private function movement():Void
	{	
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
}