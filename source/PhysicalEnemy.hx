package;

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
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic(AssetPaths.physicalEnemy__png, true, 128, 128);
		setSize(104, 104);
		offset.set(12, 12);
		
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
		health = 30;
	}
	
	private override function enterTransition():Int
	{
		currSpeed = 20;
		movementAngle = 90;
		actionState.activeState = enterState;
		actionState.nextTransition = normMoveTransition;
		return 30;
	}
	
	private override function normMoveTransition():Int
	{
		if (facing == FlxObject.RIGHT)
			movementAngle = 0;
		else if (facing == FlxObject.LEFT)
			movementAngle = 180;
		
		currSpeed = 50;
		
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
		
		currSpeed = 0;
		
		fireProjectile(70, 200);
		fireProjectile(90, 200);
		fireProjectile(110, 200);
		
		actionState.activeState = firingProjState;
		actionState.nextTransition = normMoveTransition;
		return 30;
	}
	
	public override function update(elapsed:Float)
	{
		movement();
		super.update(elapsed);
	}
}