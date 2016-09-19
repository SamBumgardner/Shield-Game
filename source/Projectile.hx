package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author Samuel Bumgardner
 */
class Projectile extends FlxSprite
{
	public var damage:Float;
	public var force:Int;
	
	private var projectileGroup:Int = 0; // 0 = no group, 1 = enemy, 2 = player
	public var currentlyCaught:Bool = false;
	
	public static inline var EN:Int = 0x00;
	public static inline var PHYS:Int = 0x01;
	public static inline var BIO:Int = 0x10;
	
	//public var groupID:FlxBasic;
	
	public function new(projectileType:Int) 
	{
		super();
		
		switch projectileType
		{
			case EN:		loadGraphic(AssetPaths.energyBullet__png, true, 32, 32);
			case PHYS:	loadGraphic(AssetPaths.energyBullet__png, true, 32, 32); // replace this with physical bullet asset when possible
			case BIO:		loadGraphic(AssetPaths.energyBullet__png, true, 32, 32); // replace this with bio bullet asset when possible.
			default: /*Shouldn't happen*/ projectileType;
		}
		setSize(16, 16);
		offset.set(8, 8);
		
		animation.add("enemy", [0], 1, false);
		animation.add("caught", [1], 1, false);
		animation.add("released", [1], 1, false, false, true);
		
		force = 50;
		damage = 1;
	}
	
	
	// Called each time the projectile is recycled
	
	public function init(X:Float, Y:Float, rotation:Float, speed:Float):Void
	{
		reset(0, 0);
		x = X;
		y = Y;
		velocity.set(speed, 0);
		velocity.rotate(FlxPoint.weak(0, 0), rotation);
		animation.play("enemy");
	}
	
	
	// Called when projectile's hitbox overlaps with something that can be damaged.
	
	public function deadlyCollide():Void
	{
		kill();
	}
	
	public function shieldCollide():Void
	{
		velocity.set(0, 0);
		projectileGroup = 2;
		(cast FlxG.state)._grpEnemyProj.remove(cast this, true);
		(cast FlxG.state)._grpPlayerProj.add(this);
		animation.play("caught");
	}
	
	override public function kill():Void
	{
		if (projectileGroup == 1)
			(cast FlxG.state)._grpEnemyProj.remove(cast this, true);
		else if (projectileGroup == 2)
			(cast FlxG.state)._grpPlayerProj.remove(cast this, true);
		projectileGroup = 0;
		
		if (currentlyCaught)
		{
			(cast FlxG.state)._robotChar.shield.caughtProjectiles.remove(cast this, true);
			currentlyCaught = false;
		}
		
		super.kill();
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (!currentlyCaught && !isOnScreen())
		{
			kill();
		}
		super.update(elapsed);
	}
}