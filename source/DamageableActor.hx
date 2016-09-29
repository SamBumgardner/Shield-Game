package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Samuel Bumgardner
 */
class DamageableActor extends FlxSprite
{
	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	
	private var healthState:FSM;
	private var vulnerable:Bool = true;
	private var hurtTime:Int;
	private var recoveryTime:Int;
	private var injuredColor:Int;
	private var alreadyHurtColor:Bool;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		healthState = new FSM(normState);
	}
	
	
	///////////////////////////////////////////
	//           GENERAL FUNCTIONS           //
	///////////////////////////////////////////
	
	// adjustColor(colorChange:Int):Int
	//
	// subtracts/adds colorChange from the sprite's current tint 
	// color using bitwise XOR. 
	// Sets new color when called with a new parameter.
	// Changes color back when called with the same parameter 
	// a second time.
	
	private function adjustColor(colorChange:Int):Int
	{
		set_color(color ^ colorChange);
		return color;
	}
	
	// damaged(damage:Float):Void
	//
	// Called when the DamageableActor should take damage.
	// Initiates change in the actor's healthState.
	
	public function damaged(damage:Float):Void
	{
		if (vulnerable == true)
		{
			hurt(damage);
			healthState.transitionStates(hurtTransition);
		}
	}
	
	
	///////////////////////////////////////////
	//        HEALTHSTATE TRANSITIONS        //
	///////////////////////////////////////////
	
	// Transition functions are used by a FSM to trigger switches 
	// between states. 
	// They have a number of responsibilities: 
	//  
	//  * Call any functions and change any variables that should
	//    only be done once, when a state begins.
	//  
	//  * Set the current state of their FSM.
	//  
	//  * Return the number of frames that the state should last.
	//    Returning -1 means the state lasts until a new transition
	//    is called.
	//
	//  * If the state is on a timer, set the FSM's nextTransition
	//    variable to whatever transtion function should be called
	//    when the current state's timer expires.
	
	
	private function normTransition():Int
	{
		alpha = 1;
		healthState.activeState = normState;
		vulnerable = true;
		return -1;
	}
	
	private function hurtTransition():Int
	{
		if (!alreadyHurtColor)
		{
			adjustColor(injuredColor);
			alreadyHurtColor = true;
		}
		healthState.activeState = hurtState;
		healthState.nextTransition = recoveryTransition;
		vulnerable = false;
		return hurtTime;
	}
	
	private function recoveryTransition():Int
	{
		adjustColor(injuredColor);
		alreadyHurtColor = false;
		healthState.activeState = recoveryState;
		healthState.nextTransition = normTransition;
		vulnerable = false;
		return recoveryTime;
	}
	
	
	///////////////////////////////////////////
	//          HEALTHSTATE  STATES          //
	///////////////////////////////////////////
	
	// State functions are essentially extensions to their class's 
	// update function. If a state is active, it will be called 
	// when its FSM's update function is called.
	
	
	private function normState():Void
	{
		return;
	}
	
	private function hurtState():Void
	{
		return;
	}
	
	private function recoveryState():Void
	{
		if (healthState.stateTimer % 16 < 8)
			set_alpha(0);
		else
			set_alpha(1);
	}
	
	
	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////
	
	public override function update(elapsed:Float):Void
	{
		healthState.update();
		super.update(elapsed);
	}
}