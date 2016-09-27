package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Samuel Bumgardner
 */
class EnemySpawner extends FlxSprite
{
	private var timerLength:Int = 300;
	private var timerValue:Int = 0;
	
	private var enemyXMargin:Int = 300;
	private var enemyYOffset:Int = -64;
	
	public var physEnemyPool:FlxTypedGroup<PhysicalEnemy>;
	public var bioEnemyPool:FlxTypedGroup<BioEnemy>;
	private var startingPoolSize:Int = 4;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		if (physEnemyPool == null)
		{
			physEnemyPool = new FlxTypedGroup<PhysicalEnemy>();
			for (i in 0...(startingPoolSize))
			{
				var physEnemy = new PhysicalEnemy();
				physEnemy.kill();
				physEnemyPool.add(physEnemy);
				(cast FlxG.state)._grpEnemies.add(physEnemy);
			}
		}
		
		if (bioEnemyPool == null)
		{
			bioEnemyPool = new FlxTypedGroup<BioEnemy>();
			for (i in 0...(startingPoolSize))
			{
				var bioEnemy = new BioEnemy();
				bioEnemy.kill();
				bioEnemyPool.add(bioEnemy);
				(cast FlxG.state)._grpEnemies.add(bioEnemy);
			}
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
	
	private function spawnPhysEnemy():Void
	{
		var newEnemy = physEnemyPool.recycle(PhysicalEnemy);
		newEnemy.init(Math.min(Math.max(Math.random() * FlxG.width, enemyXMargin), FlxG.width - enemyXMargin), enemyYOffset);
		(cast FlxG.state)._grpEnemies.add(newEnemy);
		(cast FlxG.state)._grpActors.add(newEnemy);
	}
	
	private function spawnBioEnemy():Void
	{
		var newEnemy = bioEnemyPool.recycle(BioEnemy);
		newEnemy.init(Math.min(Math.max(Math.random() * FlxG.width, enemyXMargin), FlxG.width - enemyXMargin), enemyYOffset);
		(cast FlxG.state)._grpEnemies.add(newEnemy);
		(cast FlxG.state)._grpActors.add(newEnemy);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (checkTimer())
		{
			spawnPhysEnemy();
			spawnBioEnemy();
		}
		super.update(elapsed);
	}
	
}