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
	
	private var projectileGroup:Int = 0;
	
	public var groupID:FlxBasic;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super();
		loadGraphic(AssetPaths.energy_bullet__png, true, 32, 32);
		setSize(16, 16);
		offset.set(8, 8);
		
		force = 5;
		damage = 1;
	}
	
	
	// Called each the projectile is recycled
	
	public function init(X:Float, Y:Float, rotation:Float, speed:Float):Void
	{
		x = X;
		y = Y;
		velocity.set(speed, 0);
		velocity.rotate(FlxPoint.weak(0, 0), rotation);
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
		(cast FlxG.state)._grpEnemyProj.remove(cast groupID, true);
		groupID = (cast FlxG.state)._grpPlayerProj.add(this);
	}
	
	override public function kill():Void
	{
		if (projectileGroup == 1)
			(cast FlxG.state)._grpEnemyProj.remove(cast groupID, true);
		else if (projectileGroup == 2)
			(cast FlxG.state)._grpPlayerProj.remove(cast groupID, true);
		projectileGroup = 0;
		super.kill();
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (!isOnScreen())
		{
			kill();
		}
		super.update(elapsed);
	}
}