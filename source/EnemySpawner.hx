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
	private var enemyYOffset:Int = -100;
	
	public var enemyPool:FlxTypedGroup<PhysicalEnemy>;
	private var startingPoolSize:Int = 4;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		if (enemyPool == null)
		{
			enemyPool = new FlxTypedGroup<PhysicalEnemy>();
			for (i in 0...(startingPoolSize))
			{
				var physEnemy = new PhysicalEnemy();
				physEnemy.kill();
				enemyPool.add(physEnemy);
				(cast FlxG.state)._grpEnemies.add(physEnemy);
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
	
	private function spawnEnemy():Void
	{
		var newEnemy = enemyPool.recycle(PhysicalEnemy);
		newEnemy.init(Math.min(Math.max(Math.random() * FlxG.width, enemyXMargin), FlxG.width - enemyXMargin), enemyYOffset);
		(cast FlxG.state)._grpEnemies.add(newEnemy);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (checkTimer())
		{
			spawnEnemy();
		}
		super.update(elapsed);
	}
	
}