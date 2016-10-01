package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

/**
 * ...
 * @author Samuel Bumgardner
 */
class UI
{
	public var uiInitialMenu:FlxTypedGroup<FlxText>;
	public var uiBarSprites:FlxTypedGroup<FlxSprite>;
	public var uiGameOver:FlxTypedGroup<FlxText>;
	
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
		uiInitialMenu = new FlxTypedGroup<FlxText>();
		uiBarSprites = new FlxTypedGroup<FlxSprite>();
		uiGameOver = new FlxTypedGroup<FlxText>();
		
		setUpInitialMenu(robot, mechanic);
		
		setUpCapacityBar(robot, 265, 900);
		setUpMechHealth(mechanic, 35, 900);
		setUpRoboHealth(robot, 1050, 900);
		
		setUpGameOver();
	}
	
	public function setUpInitialMenu(robot:RobotChar, mechanic:MechanicChar):Void
	{
		var titleText = new FlxText(0, 36, 0, "SHIELD GAME", 48);
		titleText.x = FlxG.width / 2 - titleText.width / 2;
		uiInitialMenu.add(titleText);
		
		var byLine = new FlxText(0, 98, 0, "by Alex Mullins and Sam Bumgardner", 12);
		byLine.x = FlxG.width / 2 - byLine.width / 2;
		uiInitialMenu.add(byLine);
		
		
		var center = mechanic.getMidpoint();
		
		var up  	= new FlxText(center.x, center.y - 80, "UP", 18);
		var down 	= new FlxText(center.x, center.y + 64, "DOWN", 18);
		var left	= new FlxText(center.x - 48, center.y, "LEFT", 18);
		var right	= new FlxText(center.x + 48, center.y, "RIGHT", 18);
		
		up.x	-= up.width / 2;
		down.x 	-= down.width / 2;
		left.x 	-= left.width;
		
		uiInitialMenu.add(up);
		uiInitialMenu.add(down);
		uiInitialMenu.add(left);
		uiInitialMenu.add(right);
		
		
		center = robot.getMidpoint();
		
		up  	= new FlxText(center.x, center.y - 96, "W", 18);
		down 	= new FlxText(center.x, center.y + 80, "S", 18);
		left	= new FlxText(center.x - 80, center.y, "A", 18);
		right	= new FlxText(center.x + 80, center.y, "D", 18);
		var space = new FlxText(center.x, center.y - 144, "SPACE", 32);
		space.color = FlxColor.CYAN;
		
		up.x	-= up.width / 2;
		down.x 	-= down.width / 2;
		left.x 	-= left.width;
		space.x	-= space.width / 2;
		
		uiInitialMenu.add(up);
		uiInitialMenu.add(down);
		uiInitialMenu.add(left);
		uiInitialMenu.add(right);
		uiInitialMenu.add(space);
	}
	
	public function hideInitialMenu():Void
	{
		var exitAnim = function(text:FlxText) 
		{
			var y = text.y;
			var kill = function(_){text.kill(); };
			FlxTween.tween(text, {alpha: 0, y: y - 4}, .3, {onComplete:kill}); 	
		};
		
		uiInitialMenu.forEach(exitAnim);
	}
	
	private function setUpCapacityBar(robot:RobotChar, X:Int, Y:Int):Void
	{
		_capacityBg = new FlxSprite(X-3, Y, AssetPaths.capacity_bg__png);
		_capacityBg.alpha = .5;
		uiBarSprites.add(_capacityBg);
		
		_capacityFg = new FlxSprite(X, Y, AssetPaths.capacity_fg__png);
		
		_capacityBar = new FlxBar(X, Y, LEFT_TO_RIGHT, 750, 50, robot, "shieldCurrCapacity", 0, robot.shieldMaxCapacity);
		_capacityBar.createGradientBar([], [0xccff0000, 0xcc00ffff]); 
		_capacityBar.numDivisions = 500;
		uiBarSprites.add(_capacityBar);
		
		uiBarSprites.add(_capacityFg);
		
		_capacityBarText = new FlxText(0, Y - 32, 0, "Shield Capacity", 16);
		_capacityBarText.x = X + 375 - _capacityBarText.width / 2;
		uiBarSprites.add(_capacityBarText);
	}
	
	private function setUpMechHealth(mechanic:MechanicChar, X:Int, Y:Int):Void
	{
		
		_mechHealthBg = new FlxSprite(X-3, Y, AssetPaths.health_bg__png);
		_mechHealthBg.alpha = .5;
		uiBarSprites.add(_mechHealthBg);
		
		_mechHealthFg = new FlxSprite(X, Y, AssetPaths.health_fg__png);
		
		_mechHealthBar = new FlxBar(X, Y, LEFT_TO_RIGHT, 200, 50, mechanic, "health", 0, 5);
		_mechHealthBar.createGradientBar([], [0xcc88ff88, 0xcc00ff00]); 
		_mechHealthBar.numDivisions = 5;
		uiBarSprites.add(_mechHealthBar);
		
		uiBarSprites.add(_mechHealthFg);
		
		_mechHealthBarText = new FlxText(0, Y - 32, 0, "Mechanic Health", 16);
		_mechHealthBarText.x = X + 100 - _mechHealthBarText.width / 2;
		uiBarSprites.add(_mechHealthBarText);
	}
	
	private function setUpRoboHealth(robot:RobotChar, X:Int, Y:Int):Void
	{
		_robotHealthBg = new FlxSprite(X-3, Y, AssetPaths.health_bg__png);
		_robotHealthBg.alpha = .5;
		uiBarSprites.add(_robotHealthBg);
		
		_robotHealthFg = new FlxSprite(X, Y, AssetPaths.health_fg__png);
		
		_robotHealthBar = new FlxBar(X, Y, LEFT_TO_RIGHT, 200, 50, robot, "health", 0, 100);
		_robotHealthBar.createGradientBar([], [0xcc88ff88, 0xcc00ff00]); 
		_robotHealthBar.numDivisions = 100;
		uiBarSprites.add(_robotHealthBar);
		
		uiBarSprites.add(_robotHealthFg);
		
		_robotHealthBarText = new FlxText(0, Y - 32, 0, "Robot Health", 16);
		_robotHealthBarText.x = X + 100 - _robotHealthBarText.width / 2;
		uiBarSprites.add(_robotHealthBarText);
	}
	
	public function setUpGameOver():Void
	{
		var gameOverText = new FlxText(0, 450, 0, "GAME OVER", 72);
		gameOverText.x = FlxG.width / 2 - gameOverText.width / 2;
		uiGameOver.add(gameOverText);
		
		var restartText = new FlxText(0, 550, 0, "Press 'R' to restart.", 12);
		restartText.x = FlxG.width / 2 - restartText.width / 2;
		uiGameOver.add(restartText);
	}
}