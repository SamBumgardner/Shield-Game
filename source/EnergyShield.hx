package;

import flixel.FlxG;
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
	private var preferredCaughtDist:Float = 50;
	private var caughtProjSpeed:Float = 150;
	
	private var projectileCounter:Int = 0;
	
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
		caughtProjectiles.forEach(fireProjectile);
		projectileCounter = 0;
		caughtProjectiles.clear();
	}
	
	public function on():Void
	{
		hidden = false;
	}
	
	public function projectileCollide(proj:Projectile):Void
	{
		caughtProjectiles.add(proj);
		proj.currentlyCaught = true;
	}
	
	public function fireProjectile(proj:Projectile):Void
	{
		proj.currentlyCaught = false;
		proj.velocity.set(0, -200);
		var angle = 0.0;
		
		if ((cast FlxG.state)._robotChar._left)
			angle -= 45;
		if ((cast FlxG.state)._robotChar._right)
			angle += 45;
		if ((cast FlxG.state)._robotChar._down)
			if (angle > 0)
				angle += 15
			else if (angle == 0)
			{
				if (projectileCounter % 3 == 2)
					angle += 30;
				else if (projectileCounter % 3 == 1)
					angle -= 30;
				// if projectile counter % 3 == 0
					// Then do not change angle.
				projectileCounter++;
			}
			else
				angle -= 15;
		if ((cast FlxG.state)._robotChar._up)
			angle /= 2;
		
		proj.velocity.rotate(FlxPoint.weak(0, 0), angle);
		
		proj.animation.play("released");
	}
	
	private function moveProjectiles(proj:Projectile):Void
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