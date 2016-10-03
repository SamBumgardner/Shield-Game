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
	public var shieldMaxCapacity:Int = 1000;
	public var shieldCurrCapacity:Int = 0;
	private var shieldCapacityCooldown:Int = 2;
	private var shieldRaiseDelay:Int = 30;
	private var shieldDropDelay:Int = 30;
	
	private var spacebar:Bool;
	
	public var shield:EnergyShield;
	public var shieldGraphic:FlxSprite;
	private var shieldOffsetY = -12;
	private var shieldOffsetX = 0;

	private var brokenSpeed:Int = 50;
	private var brokenColor:Int = 0x888888;
	
	private var deadSpeed:Int = 120;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.robotSheet__png, true, 250, 200);
		setSize(104, 104);
		offset.set(73, 76);
		
		animation.add("u", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 15);
		animation.add("l", [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31], 15);
		animation.add("r", [32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47], 15);
		animation.add("shield_raise", [48, 49, 50], 6, false);
		animation.add("shield_raised", [50], 1, true);
		animation.add("shield_lower", [50, 51, 52], 6, false);
		animation.add("defeated", [53, 54], 1, false);
		
		speed = shieldInactiveSpeed;
		health = 100;
		hurtTime = 4;
		recoveryTime = 0;
		injuredColor = 0x555555;
		
		force = 1;
		
		shieldState = new FSM(inactiveShieldState);
		
		shield = new EnergyShield();
		
		shieldGraphic = new FlxSprite(x, y);
		shieldGraphic.ignoreDrawDebug = true;
		shieldGraphic.set_alpha(.5);
		shieldGraphic.offset.set(73, 115);
		shieldGraphic.visible = false;
		shieldGraphic.loadGraphic(AssetPaths.shield__png, true, 250, 200);
		shieldGraphic.animation.add("activating", [0, 1, 2], 12, false);
		
		FlxG.state.add(shield);
	}
	
	override private function checkInputs():Void
	{
		_up = FlxG.keys.anyPressed([W]);
		_down = FlxG.keys.anyPressed([S]);
		_left = FlxG.keys.anyPressed([A]);
		_right = FlxG.keys.anyPressed([D]);
		spacebar = FlxG.keys.checkStatus(32, PRESSED);
	}
	
	override public function kill():Void
	{
		healthState.transitionStates(deadTransition);
	}
	
	public function addToCapacity(force:Int):Void
	{
		shieldCurrCapacity += force;
	}
	
	private function deadTransition():Int
	{
		shieldState.transitionStates(brokenTransition);
		healthState.transitionStates(recoveryTransition);
		adjustColor(injuredColor);
		animation.play("defeated");
		noMoveAnim = true;
		isDead = true;
		velocity.set(0, deadSpeed);
		healthState.activeState = deadState;
		return -1;
	}
	
	private function deadState():Void
	{
		velocity.set(0, deadSpeed);
		return;
	}
	
	private function inactiveTransition():Int
	{
		speed = shieldInactiveSpeed;
		noMoveAnim = false;
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
		animation.play("shield_raise", true);
		noMoveAnim = true;
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
		noMoveAnim = false;
		shield.on();
		shieldGraphic.visible = true;
		shieldGraphic.animation.play("activating");
		shieldGraphic.animation.finishCallback = function(_) { return; };
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
		if (shield.off())
		{
			shieldGraphic.animation.play("activating", true, true);
			shieldGraphic.animation.finishCallback = function(_) { shieldGraphic.visible = false; };
		}
		animation.play("shield_lower", true);
		noMoveAnim = true;
		shieldState.activeState = releasingShieldState;
		shieldState.nextTransition = inactiveTransition;
		return 30; //should be replaced with however long the animation is.
	}
	
	private function releasingTransitionEarly():Int
	{
		var currFrame = (animation.frameIndex - 50) * -1;
		trace(currFrame);
		releasingTransition();
		animation.play("shield_raise", true, true, currFrame);
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
		if (!isDead)
		{
			checkInputs();
			movement();
			shieldState.update();
			shield.updatePosition(elapsed, x - offset.x + shieldOffsetX, y - offset.y + shieldOffsetY);
		}
		shieldGraphic.velocity = velocity;
		super.update(elapsed);
	}
}