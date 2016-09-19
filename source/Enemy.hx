package;

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
	
	private var projectilePool:FlxTypedGroup<Projectile>;
	
	private var actionState:FSM;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		actionState = new FSM();
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
	
	private function movement():Void
	{
		velocity.set(currSpeed, 0);
		velocity.rotate(FlxPoint.weak(0, 0), movementAngle);
	}
	
	private function decideDirection():Void{}
	
	private function fireProjectile(firingAngle:Float, firingSpeed:Float):Void
	{
		var newProjectile = projectilePool.recycle(Projectile); //Need to fix this because projectile now takes an argument.
		newProjectile.init(getMidpoint().x, getMidpoint().y, firingAngle, firingSpeed);
		(cast FlxG.state)._grpEnemyProj.add(newProjectile);
	}
	
	
	/*============================== Action State Machine ======================================*/
	
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
	
	public override function update(elapsed:Float)
	{
		actionState.update();
		super.update(elapsed);
	}
	
}