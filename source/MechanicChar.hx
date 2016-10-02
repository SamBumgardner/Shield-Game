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
		
		loadGraphic(AssetPaths.defended__png, true, 64, 101);
		setSize(32, 32);
		offset.set(16, 34);
		
		//setFacingFlip(FlxObject.LEFT, false, false);
		//setFacingFlip(FlxObject.RIGHT, true, false);
		//
		//animation.add("lr", [3, 4, 3, 5], 6, false);
		//animation.add("u", [6, 7, 6, 8], 6, false);
		//animation.add("d", [0, 1, 0, 2], 6, false);
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