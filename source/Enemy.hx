package;

import flixel.FlxBasic.FlxType;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Samuel Bumgardner
 */
class Enemy extends DamageableActor
{
	public var maxSpeed:Float;
	public var currSpeed:Float;
	private var movementAngle:Float;
	
	public var xSpeed:Float;
	public var ySpeed:Float;
	
	public var force:Int = 1;
	
	private var projectilePool:FlxTypedGroup<Projectile>;
	private static var repairPowerupPool:FlxTypedGroup<RepairPowerup>;
	
	
	private var actionState:FSM;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		actionState = new FSM();
		hurtTime = 4;
		recoveryTime = 0;
		injuredColor = 0x333333;
		
		if (Enemy.repairPowerupPool == null)
		{
			initializeRepairPowerupPool();
		}
	}
	
	public static function gameOverPoolCleanup():Void
	{
		PhysicalEnemy.physProjectilePool = null;
		BioEnemy.bioProjectilePool = null;
		EnergyEnemy.enProjectilePool = null;
		Enemy.repairPowerupPool = null;
	}
	
	private function initializeProjectilePool(type:Int):Void
	{
		for (i in 0...30)
		{
			var projectile = new Projectile(type);
			projectile.kill();
			projectilePool.add(projectile);
		}
		FlxG.state.add(projectilePool);
	}
	
	private function initializeRepairPowerupPool():Void
	{
		Enemy.repairPowerupPool = new FlxTypedGroup<RepairPowerup>();
		for (i in 0...10)
		{
			var powUp = new RepairPowerup();
			powUp.kill();
			Enemy.repairPowerupPool.add(powUp);
		}
	}
	
	public function init(X:Float, Y:Float):Void
	{
		reset(0, 0);
		x = X;
		y = Y;
		actionState.transitionStates(enterTransition);
	}
	
	private override function hurtTransition():Int
	{
		super.hurtTransition();
		vulnerable = true;
		return hurtTime;
	}
	
	private override function recoveryTransition():Int
	{
		super.recoveryTransition();
		vulnerable = true;
		return recoveryTime;
	}
	
	private function angledMovement():Void
	{
		velocity.set(currSpeed, 0);
		velocity.rotate(FlxPoint.weak(0, 0), movementAngle);
	}
	private function componentMovement():Void
	{
		velocity.set(xSpeed, ySpeed);
	}
	
	private function decideDirection():Void{}
	
	private function projFactory(projType:Int):Projectile
	{
		return new Projectile(projType);
	}
	
	private function fireProjectile(firingAngle:Float, firingSpeed:Float, projType:Int):Void
	{
		var newProjectile = projectilePool.recycle(Projectile, projFactory.bind(projType)); 
		newProjectile.init(getMidpoint().x - 8, getMidpoint().y - 8, firingAngle, firingSpeed);
		(cast FlxG.state)._grpEnemyProj.add(newProjectile);
	}
	
	private function spawnRepairPowerup():Void
	{
		var newRepairPowerup = repairPowerupPool.recycle(RepairPowerup);
		newRepairPowerup.init(getMidpoint().x - 8, getMidpoint().y - 8);
		(cast FlxG.state)._grpBackgroundSprites.add(newRepairPowerup);
		(cast FlxG.state)._grpPowerups.add(newRepairPowerup);
	}
	
	
	/*============================== Action State Machine ======================================*/
	
	private function enterTransition():Int
	{
		return -1;
	}
	
	private function enterState():Void
	{
		return;
	}
	
	private function normMoveTransition():Int
	{
		return -1;
	}
	
	private function normMoveState():Void
	{
		return;
	}
	
	private function firingProjTransition():Int
	{
		return -1;
	}
	
	private function firingProjState():Void
	{
		return;
	}
	
	override public function kill():Void
	{
		(cast FlxG.state)._grpEnemies.remove(cast this, true);
		(cast FlxG.state)._grpActors.remove(cast this, true);
		if (health <= 0)
		{
			(cast FlxG.state).increaseMultiplier();
			(cast FlxG.state).increaseScore(75);
		}
		super.kill();
	}
	
	public override function update(elapsed:Float)
	{
		if (!isOnScreen())
			kill();
		actionState.update();
		super.update(elapsed);
	}
	
}