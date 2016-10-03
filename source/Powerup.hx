package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Samuel Bumgardner
 */
class Powerup extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
	}
	
	public function init(X:Float, Y:Float):Void
	{
		reset(0, 0);
		x = X;
		y = Y;
		velocity.y = 120;
	}
	
	public function powerupEffect():Void
	{
		kill();
	}
	
	override public function kill():Void
	{
		(cast FlxG.state)._grpPowerups.remove(cast this, true);
		(cast FlxG.state)._grpBackgroundSprites.remove(cast this, true);
		super.kill();
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