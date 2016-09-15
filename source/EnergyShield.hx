package;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author Samuel Bumgardner
 */
class EnergyShield extends FlxSprite
{

	private var hidden:Bool;
	
	private var caughtProjectiles:FlxTypedGroup<Projectile>;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		makeGraphic(256, 64, FlxColor.BLUE);
		
		caughtProjectiles = new FlxTypedGroup<Projectile>();
		
		off();
	}
	
	public function off():Void
	{
		hidden = true;
		y = -height;
	}
	
	public function on():Void
	{
		hidden = false;
	}
	
	public function projectileCollide(proj:Projectile):Void
	{
		caughtProjectiles.add(proj);
	}
	
	public function updatePosition(elapsed:Float, X:Float, Y:Float):Void
	{
		if (!hidden)
		{
			x = X;
			y = Y;
			//iterate through caughtProjectiles and update positions.
		}
		update(elapsed);
	}
}