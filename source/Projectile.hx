package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author Samuel Bumgardner
 */
class Projectile extends FlxSprite
{
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super();
		loadGraphic(AssetPaths.energy_bullet__png, true, 32, 32);
		setSize(16, 16);
		offset.set(8, 8);
	}
	
	
	// Called each the projectile is recycled
	
	public function init(X:Float, Y:Float, rotation:Float, speed:Float):Void
	{
		x = X;
		y = Y;
		velocity.set(speed, 0);
		velocity.rotate(FlxPoint.weak(0, 0), rotation);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (!isOnScreen())
		{
			kill();
		}
		super.update(elapsed);
	}
}