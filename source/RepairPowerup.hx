package;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Samuel Bumgardner
 */
class RepairPowerup extends Powerup
{
	private static var healAmount = 2;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		makeGraphic(48, 48, 0xff0000ff);
	}
	
	override public function powerupEffect():Void
	{
		(cast FlxG.state)._robotChar.heal(RepairPowerup.healAmount);
		super.powerupEffect();
	}
}