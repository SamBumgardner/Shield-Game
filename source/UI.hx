package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

/**
 * ...
 * @author Samuel Bumgardner
 */
class UI
{
	public var _uiBarSprites:FlxTypedGroup<FlxSprite>;
	
	private var _capacityBg:FlxSprite;
	private var _capacityBar:FlxBar;
	private var _capacityFg:FlxSprite;
	private var _capacityBarText:FlxText;
	
	private var _mechHealthBg:FlxSprite;
	private var _mechHealthBar:FlxBar;
	private var _mechHealthFg:FlxSprite;
	private var _mechHealthBarText:FlxText;
	
	private var _robotHealthBg:FlxSprite;
	private var _robotHealthBar:FlxBar;
	private var _robotHealthFg:FlxSprite;
	private var _robotHealthBarText:FlxText;
	
	public function new(robot:RobotChar, mechanic:MechanicChar) 
	{
		_uiBarSprites = new FlxTypedGroup<FlxSprite>();
		
		setUpCapacityBar(robot, 265, 900);
		setUpMechHealth(mechanic, 35, 900);
		setUpRoboHealth(robot, 1050, 900);
	}
	
	private function setUpCapacityBar(robot:RobotChar, X:Int, Y:Int):Void
	{
		_capacityBg = new FlxSprite(X-3, Y, AssetPaths.capacity_bg__png);
		_capacityBg.alpha = .5;
		_uiBarSprites.add(_capacityBg);
		
		_capacityFg = new FlxSprite(X, Y, AssetPaths.capacity_fg__png);
		
		_capacityBar = new FlxBar(X, Y, LEFT_TO_RIGHT, 750, 50, robot, "shieldCurrCapacity", 0, robot.shieldMaxCapacity);
		_capacityBar.createGradientBar([], [0xccff0000, 0xcc00ffff]); 
		_capacityBar.numDivisions = 500;
		_uiBarSprites.add(_capacityBar);
		
		_uiBarSprites.add(_capacityFg);
		
		_capacityBarText = new FlxText(0, Y - 32, 0, "Shield Capacity", 16);
		_capacityBarText.x = X + 375 - _capacityBarText.width / 2;
		_uiBarSprites.add(_capacityBarText);
	}
	
	private function setUpMechHealth(mechanic:MechanicChar, X:Int, Y:Int):Void
	{
		
		_mechHealthBg = new FlxSprite(X-3, Y, AssetPaths.health_bg__png);
		_mechHealthBg.alpha = .5;
		_uiBarSprites.add(_mechHealthBg);
		
		_mechHealthFg = new FlxSprite(X, Y, AssetPaths.health_fg__png);
		
		_mechHealthBar = new FlxBar(X, Y, LEFT_TO_RIGHT, 200, 50, mechanic, "health", 0, 5);
		_mechHealthBar.createGradientBar([], [0xcc88ff88, 0xcc00ff00]); 
		_mechHealthBar.numDivisions = 5;
		_uiBarSprites.add(_mechHealthBar);
		
		_uiBarSprites.add(_mechHealthFg);
		
		_mechHealthBarText = new FlxText(0, Y - 32, 0, "Mechanic Health", 16);
		_mechHealthBarText.x = X + 100 - _mechHealthBarText.width / 2;
		_uiBarSprites.add(_mechHealthBarText);
	}
	
	private function setUpRoboHealth(robot:RobotChar, X:Int, Y:Int):Void
	{
		_robotHealthBg = new FlxSprite(X-3, Y, AssetPaths.health_bg__png);
		_robotHealthBg.alpha = .5;
		_uiBarSprites.add(_robotHealthBg);
		
		_robotHealthFg = new FlxSprite(X, Y, AssetPaths.health_fg__png);
		
		_robotHealthBar = new FlxBar(X, Y, LEFT_TO_RIGHT, 200, 50, robot, "health", 0, 100);
		_robotHealthBar.createGradientBar([], [0xcc88ff88, 0xcc00ff00]); 
		_robotHealthBar.numDivisions = 100;
		_uiBarSprites.add(_robotHealthBar);
		
		_uiBarSprites.add(_robotHealthFg);
		
		_robotHealthBarText = new FlxText(0, Y - 32, 0, "Robot Health", 16);
		_robotHealthBarText.x = X + 100 - _robotHealthBarText.width / 2;
		_uiBarSprites.add(_robotHealthBarText);
	}
}