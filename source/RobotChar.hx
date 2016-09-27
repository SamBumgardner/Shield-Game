package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;

/**
 * ...
 * @author Samuel Bumgardner
 */
class RobotChar extends PlayerChar
{
	private var shieldState:FSM;
	
	private var shieldActiveSpeed:Int = 100;
	private var shieldInactiveSpeed:Int = 160;
	private var shieldMaxCapacity:Int = 1000;
	private var shieldCurrCapacity:Int = 0;
	private var shieldCapacityCooldown:Int = 5;
	private var shieldRaiseDelay:Int = 30;
	private var shieldDropDelay:Int = 30;
	
	private var spacebar:Bool;
	
	public var shield:EnergyShield;
	private var shieldOffsetY = -70;
	private var shieldOffsetX = -64;

	private var brokenSpeed:Int = 50;
	private var brokenColor:Int = 0x888888;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.defender__png, true, 128, 128);
		setSize(104, 104);
		offset.set(12, 12);
		
		//setFacingFlip(FlxObject.LEFT, false, false);
		//setFacingFlip(FlxObject.RIGHT, true, false);
		
		//animation.add("lr", [3, 4, 3, 5], 6, false);
		//animation.add("u", [6, 7, 6, 8], 6, false);
		//animation.add("d", [0, 1, 0, 2], 6, false);
		
		speed = shieldInactiveSpeed;
		health = 100;
		hurtTime = 4;
		recoveryTime = 0;
		injuredColor = 0x555555;
		
		force = 1;
		
		shieldState = new FSM(inactiveShieldState);
		
		shield = new EnergyShield();
		FlxG.state.add(shield);
	}
	
	private override function checkInputs():Void
	{
		_up = FlxG.keys.anyPressed([W]);
		_down = FlxG.keys.anyPressed([S]);
		_left = FlxG.keys.anyPressed([A]);
		_right = FlxG.keys.anyPressed([D]);
		spacebar = FlxG.keys.checkStatus(32, PRESSED);
	}
	
	override public function kill():Void
	{
		shieldState.transitionStates(brokenTransition);
		super.kill();
	}
	
	public function addToCapacity(force:Int):Void
	{
		shieldCurrCapacity += force;
	}
	
	private function inactiveTransition():Int
	{
		speed = shieldInactiveSpeed;
		shieldState.activeState = inactiveShieldState;
		return -1;
	}
	
	private function inactiveShieldState():Void
	{
		if (spacebar)
			shieldState.transitionStates(activatingTransition);
		else if (shieldCurrCapacity > 0)
			Math.max(shieldCurrCapacity -= shieldCapacityCooldown, 0);
		
		return;
	}
	
	private function activatingTransition():Int
	{
		speed = 0;
		//Play animation of bringing up shield
		shieldState.activeState = activatingShieldState;
		shieldState.nextTransition = activeTransition;
		return 30;
	}
	
	private function activatingShieldState():Void
	{
		if (!spacebar)
			shieldState.transitionStates(releasingTransitionEarly);
		return;
	}
	
	private function activeTransition():Int
	{
		speed = shieldActiveSpeed;
		shield.on();
		shieldState.activeState = activeShieldState;
		return -1;
	}
	
	private function activeShieldState():Void
	{
		if (!spacebar)
			shieldState.transitionStates(releasingTransition);
		else if (shieldCurrCapacity > shieldMaxCapacity)
			shieldState.transitionStates(brokenTransition);
	}
	
	private function releasingTransition():Int
	{
		speed = 0;
		shield.off();
		//Play animation of returning to normal.
		shieldState.activeState = releasingShieldState;
		shieldState.nextTransition = inactiveTransition;
		return 30; //should be replaced with however long the animation is.
	}
	
	private function releasingTransitionEarly():Int
	{
		releasingTransition();
		//need to play a shorter version of the normal animation.
		return 30 - shieldState.stateTimer;
	}
	
	private function releasingShieldState():Void
	{
		return;
	}
	
	private function brokenTransition():Int
	{
		shield.broken();
		speed = brokenSpeed;
		adjustColor(brokenColor);
		shieldState.activeState = brokenShieldState;
		return -1;
	}
	
	private function brokenShieldState():Void
	{
		if (shieldCurrCapacity > 0)
			Math.max(shieldCurrCapacity -= shieldCapacityCooldown, 0);
		
		if (shieldCurrCapacity == 0)
		{
			adjustColor(brokenColor);
			shieldState.transitionStates(inactiveTransition);
		}
		
		return;
	}
	
	override public function update(elapsed:Float):Void 
	{
		movement();
		shieldState.update();
		shield.updatePosition(elapsed, x - offset.x + shieldOffsetX, y - offset.y + shieldOffsetY);
		super.update(elapsed);
	}
}