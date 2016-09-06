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
	private var speed:Int = 100;
	private var rotation:Int = 90;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		x = Math.random() * FlxG.width;
		
		setSize(50, 50);
		
		makeGraphic(50, 50, FlxColor.RED);
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