package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxSort;

class PlayState extends FlxState
{
	private var _map:FlxOgmoLoader;
	private var _terrain:FlxTilemap;
	private var _grpActors:FlxTypedGroup<FlxSprite>;
	private var _mechanicChar:MechanicChar;
	private var _robotChar:RobotChar;
	
	override public function create():Void
	{
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		_map = new FlxOgmoLoader(AssetPaths.Level0__oel);
		_terrain = _map.loadTilemap(AssetPaths.GroundTileset__png, 64, 64, "tiles");
		_terrain.follow();
		add(_terrain);
		
		_grpActors = new FlxTypedGroup<FlxSprite>();
		add(_grpActors);
		
		_mechanicChar = new MechanicChar(500,500);
		_grpActors.add(_mechanicChar);
		
		_robotChar = new RobotChar(500, 500);
		_grpActors.add(_robotChar);
		
		
		super.create();
	}
	
	private function sortByOffsetY(Order:Int, Obj1:FlxObject, Obj2:FlxObject):Int
	{
		return FlxSort.byValues(Order, Obj1.y + Obj1.height + (cast Obj1).offset.y, Obj2.y + Obj2.height + (cast Obj2).offset.y);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(_robotChar, _mechanicChar);
		_grpActors.sort(sortByOffsetY, FlxSort.ASCENDING);
	}
}