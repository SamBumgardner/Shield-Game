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
	
	private var noMoveAnim = false;
	
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
				facing = FlxObject.UP;
				if (_left)
				{
					mA -= 45;
					facing = FlxObject.LEFT;
				}
				else if (_right)
				{
					mA += 45;
					facing = FlxObject.RIGHT;
				}
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
		
			if ((velocity.x != 0 || velocity.y != 0) && !noMoveAnim)
			{
				switch (facing)
				{
					case FlxObject.LEFT:
						animation.play("l");
					case FlxObject.RIGHT:
						animation.play("r");
					case FlxObject.UP, FlxObject.DOWN:
						animation.play("u");
				}
			}
			else
			{
			}
		}
		else
		{
			if(!noMoveAnim)
				animation.play("u");
			velocity.set(0, 0);
		}
	}
}