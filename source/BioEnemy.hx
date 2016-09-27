package;

import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Samuel Bumgardner
 */
class BioEnemy extends Enemy
{
	private static var bioProjectilePool:FlxTypedGroup<Projectile>;
	
	private static var maxYSpeed:Float = 80;
	private static var maxXSpeed:Float = 20;
	
	private static var maxHealth:Int = 1;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic(AssetPaths.bioEnemy__png, true, 128, 128);
		setSize(104, 64);
		offset.set(12, 32);
		
		animation.add("walk", [0,1,2,3,4,5,6,7,8,9,10,11], 30);
		
		maxSpeed = 100;
		facing = FlxObject.RIGHT;
		
		if (BioEnemy.bioProjectilePool == null)
		{
			BioEnemy.bioProjectilePool = new FlxTypedGroup<Projectile>();
			projectilePool = BioEnemy.bioProjectilePool;
			initializeProjectilePool(Projectile.BIO);
		}
		else
		{
			projectilePool = BioEnemy.bioProjectilePool;
		}
	}
	
	override public function init(X:Float, Y:Float):Void 
	{
		super.init(X, Y);
		health = BioEnemy.maxHealth;
		actionState.activeState = enterTransition;
		animation.play("walk");
	}
	
	private function fireProjectileSpread():Void
	{
		fireProjectile(70, 200, Projectile.BIO);
		fireProjectile(90, 200, Projectile.BIO);
		fireProjectile(110, 200, Projectile.BIO);
	}
	
	private override function enterTransition():Int
	{
		ySpeed = BioEnemy.maxYSpeed;
		actionState.activeState = enterState;
		actionState.nextTransition = normMoveTransition;
		return 20;
	}
	
	private override function normMoveTransition():Int
	{
		if (facing == FlxObject.RIGHT)
			xSpeed = BioEnemy.maxXSpeed;
		else if (facing == FlxObject.LEFT)
			xSpeed = -BioEnemy.maxXSpeed;
		
		actionState.activeState = normMoveState;
		actionState.nextTransition = firingProjTransition;
		return 200;
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
		actionState.nextTransition = firingProjTransition;
		return 30;
	}
	
	public override function update(elapsed:Float)
	{
		componentMovement();
		super.update(elapsed);
	}
}