package;

/**
 * ...
 * @author Samuel Bumgardner
 */
class FSM
{
	public var activeState:Void->Void;
	public var nextTransition:Void->Int;
	public var stateTimer:Int = -1;
	
	public function new(?InitState:Void->Void):Void
	{
		activeState = InitState;
	}
	
	public function transitionStates(transitionFunc:Void->Int):Void
	{
		stateTimer = transitionFunc();
	}
	
	public function update():Void
	{
		if (activeState != null)
		{
			activeState();
			
			if(stateTimer > 0)
				stateTimer--;
			
			else if (stateTimer == 0)
				stateTimer = nextTransition();
		}
	}
}