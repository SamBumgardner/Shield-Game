package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;

/**
 * ...
 * @author Samuel Bumgardner
 */
class RobotChar extends PlayerChar
{
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.defender__png, true, 128, 128);
		setSize(104, 104);
		offset.set(12, 12);
		
		//setFacingFlip(FlxObject.LEFT, false, false);
		//setFacingFlip(FlxObject.RIGHT, true, false);
		
		//animation.add("lr", [3, 4, 3, 5], 6, false);
		//animation.add("u", [6, 7, 6, 8], 6, false);
		//animation.add("d", [0, 1, 0, 2], 6, false);
		
		speed = 160;
		health = 100;
		hurtTime = 4;
		recoveryTime = 0;
		injuredColor = 0xaaaaaa;
	}
	
	private override function checkInputs():Void
	{
		_up = FlxG.keys.anyPressed([W]);
		_down = FlxG.keys.anyPressed([S]);
		_left = FlxG.keys.anyPressed([A]);
		_right = FlxG.keys.anyPressed([D]);
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		movement();
		super.update(elapsed);
	}
}