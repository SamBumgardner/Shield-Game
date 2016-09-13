package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTileblock;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxCollision;
import flixel.util.FlxSort;

class PlayState extends FlxState
{
	private var _backdrop:FlxBackdrop;
	private var _grpCharacters:FlxTypedGroup<FlxSprite>; //Used for player-specific collisions.
	private var _grpActors:FlxTypedGroup<FlxSprite>;
	private var _grpBoundaries:FlxGroup;
	private var _mechanicChar:MechanicChar;
	private var _robotChar:RobotChar;
	
	private var _projectileSpawner:ProjectileSpawner;
	
	override public function create():Void
	{
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		_backdrop = new FlxBackdrop(AssetPaths.scrollingBackground__png);
		add(_backdrop);
		_backdrop.velocity.set(0, 120);
		
		_grpBoundaries = FlxCollision.createCameraWall(FlxG.camera, false, 15);
		add(_grpBoundaries);
		
		_grpActors = new FlxTypedGroup<FlxSprite>();
		add(_grpActors);
		
		_grpCharacters = new FlxTypedGroup<FlxSprite>();
		
		_mechanicChar = new MechanicChar(500, 500);
		_grpCharacters.add(_mechanicChar);
		_grpActors.add(_mechanicChar);
		
		_robotChar = new RobotChar(500, 500);
		_grpCharacters.add(_robotChar);
		_grpActors.add(_robotChar);
		
		_projectileSpawner = new ProjectileSpawner();
		add(_projectileSpawner);
		
		super.create();
	}
	
	private function sortByOffsetY(Order:Int, Obj1:FlxObject, Obj2:FlxObject):Int
	{
		return FlxSort.byValues(Order, Obj1.y + Obj1.height + (cast Obj1).offset.y, Obj2.y + Obj2.height + (cast Obj2).offset.y);
	}
	
	private function projectileCollisions(actor:Dynamic, projectile:Projectile)
	{
		actor.damaged(projectile.damage);
		projectile.collide();
	}

	private function separateAndRemember(Object1:FlxObject, Object2:FlxObject):Bool
	{
		var separatedX:Bool = FlxObject.separateX(Object1, Object2);
		var separatedY:Bool = FlxObject.separateY(Object1, Object2);
		
		//The following casts assume that object2 will be an instance of PlayerChar
		if(separatedX)
			(cast Object2).wallCollideX = separatedX;
		if(separatedY)
			(cast Object2).wallCollideY = separatedY;
		
		return separatedX || separatedY;
	}
	
	private function conditionalSeparate(Object1:FlxObject, Object2:FlxObject):Bool
	{
		//The following casts assume that object1 & 2 will be instances of PlayerChar
		if ((cast Object1).wallCollideX)
			Object1.immovable = true;
		else
			Object1.immovable = false;
		
		if ((cast Object2).wallCollideX)
			Object2.immovable = true;
		else
			Object2.immovable = false;
		
		var separatedX:Bool = FlxObject.separateX(Object1, Object2);
		
		
		if ((cast Object1).wallCollideY)
			Object1.immovable = true;
		else
			Object1.immovable = false;
		
		if ((cast Object2).wallCollideY)
			Object2.immovable = true;
		else
			Object2.immovable = false;
		
		var separatedY:Bool = FlxObject.separateY(Object1, Object2);
		
		(cast Object1).wallCollideX = false;
		(cast Object1).wallCollideY = false;
		Object1.immovable = false;
		
		(cast Object2).wallCollideX = false;
		(cast Object2).wallCollideY = false;
		Object2.immovable = false;
		
		
		return separatedX || separatedY;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.collide(_robotChar, _mechanicChar);
		FlxG.overlap(_grpActors, ProjectileSpawner.projectilePool, projectileCollisions);
		
		//Quick Note: The order of the groups in this call matters!
		//	_grpBoundaries comes first, then _grpCharacters
		FlxG.overlap(_grpBoundaries, _grpCharacters, null, separateAndRemember);
		FlxG.overlap(_robotChar, _mechanicChar, null, conditionalSeparate);
		
		_grpActors.sort(sortByOffsetY, FlxSort.ASCENDING);
	}
}