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
	private var physTimerLength:Int = 200;
	private var physTimerValue:Int = 0;
	private var bioTimerLength:Int = 400;
	private var bioTimerValue:Int = 0;
	private var enTimerLength:Int = 600;
	private var enTimerValue:Int = 0;
	
	private var enemyXMargin:Int = 300;
	private var enemyYOffset:Int = -64;
	
	public var physEnemyPool:FlxTypedGroup<PhysicalEnemy>;
	public var bioEnemyPool:FlxTypedGroup<BioEnemy>;
	public var enEnemyPool:FlxTypedGroup<EnergyEnemy>;
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
		
		if (enEnemyPool == null)
		{
			enEnemyPool = new FlxTypedGroup<EnergyEnemy>();
			for (i in 0...(startingPoolSize))
			{
				var enEnemy = new EnergyEnemy();
				enEnemy.kill();
				enEnemyPool.add(enEnemy);
				(cast FlxG.state)._grpEnemies.add(enEnemy);
			}
		}
	}
	
	private function checkTimer(timerLength:Int, timerValue:Int):Bool
	{
		if (timerValue == timerLength)
			return true;
		else
			return false;
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
	
	private function spawnEnEnemy():Void
	{
		var newEnemy = enEnemyPool.recycle(EnergyEnemy);
		newEnemy.init(Math.min(Math.max(Math.random() * FlxG.width, enemyXMargin*2), FlxG.width - enemyXMargin*2), enemyYOffset);
		(cast FlxG.state)._grpEnemies.add(newEnemy);
		(cast FlxG.state)._grpActors.add(newEnemy);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (checkTimer(physTimerLength, physTimerValue))
		{
			spawnPhysEnemy();
			physTimerLength = cast Math.max(physTimerLength - 1, 100);
			physTimerValue = 0;
		}
		else
		{
			physTimerValue++;
		}
		
		if (checkTimer(bioTimerLength, bioTimerValue))
		{
			spawnBioEnemy();
			bioTimerLength = cast Math.max(bioTimerLength - 1, 100);
			bioTimerValue = 0;
		}
		else
		{
			bioTimerValue++;
		}
		
		if (checkTimer(enTimerLength, enTimerValue))
		{
			spawnEnEnemy();
			enTimerLength = cast Math.max(enTimerLength - 1, 100);
			enTimerValue = 0;
		}
		else
		{
			enTimerValue++;
		}
		
		super.update(elapsed);
	}
	
}