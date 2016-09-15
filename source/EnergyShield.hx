package;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author Samuel Bumgardner
 */
class EnergyShield extends FlxSprite
{

	private var hidden:Bool;
	
	public var caughtProjectiles:FlxTypedGroup<Projectile>;
	private var preferredCaughtDist:Float = 85;
	private var caughtProjSpeed:Float = 200;
	
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
		y = -height * 2;
		caughtProjectiles.clear();
	}
	
	public function on():Void
	{
		hidden = false;
	}
	
	public function projectileCollide(proj:Projectile):Void
	{
		caughtProjectiles.add(proj);
	}
	
	public function moveProjectiles(proj:Projectile):Void
	{
		var shieldMidpoint = getMidpoint();
		var projMidpoint = proj.getMidpoint();
		
		var angle = projMidpoint.angleBetween(shieldMidpoint);
		proj.velocity.set(caughtProjSpeed, 0);
		proj.velocity.rotate(FlxPoint.weak(0, 0), angle);
			
		if (projMidpoint.distanceTo(shieldMidpoint) > preferredCaughtDist)
		{	
			if (proj.x > shieldMidpoint.x)
				proj.x -= 1;
			else
				proj.x += 1;
			
			if (proj.y > shieldMidpoint.y)
				proj.y -= 1;
			else
				proj.y += 1;
		}
	}
	
	public function updatePosition(elapsed:Float, X:Float, Y:Float):Void
	{
		if (!hidden)
		{
			x = X;
			y = Y;
		}
		update(elapsed);
	}
	
	public function updateProjectiles()
	{
		if (!hidden)
			caughtProjectiles.forEach(moveProjectiles);
	}
}