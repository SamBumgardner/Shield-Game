package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Samuel Bumgardner
 */
class ProjectileSpawner extends FlxSprite
{
	private var timerLength:Int = 30;
	private var timerValue:Int = 0;
	
	private var projectileOffsetX:Int = 0;
	private var projectileOffsetY:Int = 0;
	
	private static var projectilePool:FlxTypedGroup<Projectile>;
	private static var startingPoolSize:Int = 10;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		if (projectilePool == null)
		{
			ProjectileSpawner.projectilePool = new FlxTypedGroup<Projectile>();
			for (i in 0...(ProjectileSpawner.startingPoolSize))
			{
				var projectile = new Projectile();
				projectile.kill();
				ProjectileSpawner.projectilePool.add(projectile);
			}
			FlxG.state.add(ProjectileSpawner.projectilePool);
		}
	}
	
	private function checkTimer():Bool
	{
		if (timerValue == timerLength)
		{
			timerValue = 0;
			return true;
		}
		else
		{
			timerValue += 1;
			return false;
		}
	}
	
	private function fireProjectile():Void
	{
		ProjectileSpawner.projectilePool.recycle(Projectile);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (checkTimer())
		{
			fireProjectile();
			trace("fired Projectile!");
		}
		super.update(elapsed);
	}
	
}