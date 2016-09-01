package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxSort;

class PlayState extends FlxState
{
	private var _backdrop:FlxBackdrop;
	private var _grpActors:FlxTypedGroup<FlxSprite>;
	private var _mechanicChar:MechanicChar;
	private var _robotChar:RobotChar;
	
	override public function create():Void
	{
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		_backdrop = new FlxBackdrop(AssetPaths.scrollingBackground__png);
		add(_backdrop);
		_backdrop.velocity.set(0, 200);
		
		
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