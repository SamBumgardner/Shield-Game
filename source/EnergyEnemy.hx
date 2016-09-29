package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Samuel Bumgardner
 */
class EnergyEnemy extends Enemy
{

	private static var enProjectilePool:FlxTypedGroup<Projectile>;
	
	private static var maxYSpeed:Float = 80;
	private static var maxXSpeed:Float = 80;
	
	private static var maxHealth:Int = 3;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic(AssetPaths.energyEnemy__png, true, 120, 100);
		setSize(100, 80);
		offset.set(10, 10);
		
		animation.add("walk", [0,1,2,3,4,5,6,7,8,9,10,11], 15);
		
		maxSpeed = 100;
		facing = FlxObject.RIGHT;
		
		if (EnergyEnemy.enProjectilePool == null)
		{
			EnergyEnemy.enProjectilePool = new FlxTypedGroup<Projectile>();
			projectilePool = EnergyEnemy.enProjectilePool;
			initializeProjectilePool(Projectile.EN);
		}
		else
		{
			projectilePool = EnergyEnemy.enProjectilePool;
		}
	}
	
	override public function init(X:Float, Y:Float):Void 
	{
		super.init(X, Y);
		health = EnergyEnemy.maxHealth;
		actionState.activeState = enterTransition;
		animation.play("walk");
	}
	
	private override function enterTransition():Int
	{
		ySpeed = EnergyEnemy.maxYSpeed;
		actionState.activeState = enterState;
		actionState.nextTransition = normMoveTransition;
		return 20;
	}
	
	private override function normMoveTransition():Int
	{
		if (facing == FlxObject.RIGHT)
			xSpeed = EnergyEnemy.maxXSpeed;
		else if (facing == FlxObject.LEFT)
			xSpeed = -EnergyEnemy.maxXSpeed;
		
		actionState.activeState = normMoveState;
		actionState.nextTransition = firingProjTransition;
		return 90;
	}
	
	private override function firingProjTransition():Int
	{
		if (facing == FlxObject.RIGHT)
			facing = FlxObject.LEFT;
		else if (facing == FlxObject.LEFT)
			facing = FlxObject.RIGHT;
		
		xSpeed = 0;
		
		var angleToPlayer:Float = getMidpoint().angleBetween(
			FlxPoint.weak((cast FlxG.state)._mechanicChar.x, (cast FlxG.state)._mechanicChar.y)) - 90;
		
		fireProjectile(angleToPlayer - 5, 200, Projectile.EN);
		fireProjectile(angleToPlayer + 5, 200, Projectile.EN);
		
		actionState.activeState = firingProjState;
		actionState.nextTransition = normMoveTransition;
		return 10;
	}
	
	public override function update(elapsed:Float)
	{
		componentMovement();
		super.update(elapsed);
	}
	
}