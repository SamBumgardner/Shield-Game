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
		_backdrop.velocity.set(0, 200);
		
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
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		
		//Have to recheck collisions once to ensure that they don't pass through each other.
		FlxG.collide(_grpCharacters, _grpBoundaries);
		FlxG.collide(_robotChar, _mechanicChar);
		FlxG.collide(_grpCharacters, _grpBoundaries);
		
		
		_grpActors.sort(sortByOffsetY, FlxSort.ASCENDING);
	}
}