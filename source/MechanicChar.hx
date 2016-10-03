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
class MechanicChar extends PlayerChar
{
	private var maxTakeDamage:Int = 1;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.mechanicSheet__png, true, 80, 124);
		setSize(32, 32);
		offset.set(24, 48);
		
		animation.add("u", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 15);
		animation.add("l", [12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23], 15);
		animation.add("r", [24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35], 15);
		speed = 190;
		health = 5;
		hurtTime = 4;
		recoveryTime = 56;
		injuredColor = 0x44ffff;
		
		force = 0;
	}
	
	private override function checkInputs():Void
	{
		_up = FlxG.keys.anyPressed([UP]);
		_down = FlxG.keys.anyPressed([DOWN]);
		_left = FlxG.keys.anyPressed([LEFT]);
		_right = FlxG.keys.anyPressed([RIGHT]);
	}
	
	override public function damaged(damage:Float):Void
	{
		super.damaged(maxTakeDamage);
	}
	
	override public function kill():Void
	{
		(cast FlxG.state).gameOver();
		super.kill();
	}
	
	override public function update(elapsed:Float):Void 
	{
		checkInputs();
		movement();
		super.update(elapsed);
	}
}