package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Samuel Bumgardner
 */
class PhysicalEnemy extends Enemy
{
	
	private static var physProjectilePool:FlxTypedGroup<Projectile>;
	
	private static var maxYSpeed:Float = 60;
	private static var maxXSpeed:Float = 50;
	
	private static var maxHealth:Int = 5;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic(AssetPaths.physicalEnemy__png, true, 128, 128);
		setSize(104, 64);
		offset.set(12, 64);
		
		animation.add("walk", [0,1,2,3,4,5,6,7,8,9,10,11,10,9,8,7,6,5,4,3,2,1], 15);
		
		maxSpeed = 100;
		facing = FlxObject.RIGHT;
		
		if (PhysicalEnemy.physProjectilePool == null)
		{
			PhysicalEnemy.physProjectilePool = new FlxTypedGroup<Projectile>();
			projectilePool = PhysicalEnemy.physProjectilePool;
			initializeProjectilePool(Projectile.PHYS);
		}
		else
		{
			projectilePool = PhysicalEnemy.physProjectilePool;
		}
	}
	
	override public function init(X:Float, Y:Float):Void 
	{
		super.init(X, Y);
		health = PhysicalEnemy.maxHealth;
		actionState.activeState = enterTransition;
		animation.play("walk");
	}
	
	private function fireProjectileSpread():Void
	{
		fireProjectile(70, 200, Projectile.PHYS);
		fireProjectile(90, 200, Projectile.PHYS);
		fireProjectile(110, 200, Projectile.PHYS);
	}
	
	private override function enterTransition():Int
	{
		ySpeed = PhysicalEnemy.maxYSpeed;
		actionState.activeState = enterState;
		actionState.nextTransition = normMoveTransition;
		return 180;
	}
	
	private override function normMoveTransition():Int
	{
		if (facing == FlxObject.RIGHT)
			xSpeed = PhysicalEnemy.maxXSpeed;
		else if (facing == FlxObject.LEFT)
			xSpeed = -PhysicalEnemy.maxXSpeed;
		
		actionState.activeState = normMoveState;
		actionState.nextTransition = firingProjTransition;
		return 300;
	}
	
	private override function firingProjTransition():Int
	{
		if (facing == FlxObject.RIGHT)
			facing = FlxObject.LEFT;
		else if (facing == FlxObject.LEFT)
			facing = FlxObject.RIGHT;
		
		xSpeed = 0;
		
		fireProjectileSpread();
		
		actionState.activeState = firingProjState;
		actionState.nextTransition = normMoveTransition;
		return 30;
	}
	
	public override function update(elapsed:Float)
	{
		componentMovement();
		super.update(elapsed);
	}
}