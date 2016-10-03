package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTileblock;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;

class PlayState extends FlxTransitionableState
{
	private var _backdrop:FlxBackdrop;
	private var _grpCharacters:FlxTypedGroup<FlxSprite>; //Used for player-specific collisions.
	private var _grpEnemies:FlxTypedGroup<FlxSprite>;
	private var _grpActors:FlxTypedGroup<FlxSprite>;
	private var _grpBoundaries:FlxGroup;
	private var _grpBackgroundSprites:FlxGroup;
	private var _mechanicChar:MechanicChar;
	private var _robotChar:RobotChar;
	private var _grpUI:FlxTypedGroup<FlxSprite>;
	private var _UiManager:UI;
	private var _enemySpawner:EnemySpawner;
	
	public var _grpEnemyProj:FlxTypedGroup<Projectile>; // Pair of groups used for collision purposes.
	public var _grpPlayerProj:FlxTypedGroup<Projectile>;
	
	public var playerScore:Int = 0;
	private var _incScoreTimer:Int = 15;
	private var _maxScoreTimer:Int = 15;
	public var scoreMultiplier:Int = 1;
	public var scoreState:FSM;
	private var _scoreText:FlxText;
	private var _multText:FlxText;
	
	private var _gameStarted:Bool = false;
	private var _gameIsOver:Bool = false;
	
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
		
		_grpBackgroundSprites = new FlxGroup();
		add(_grpBackgroundSprites);
		
		_grpActors = new FlxTypedGroup<FlxSprite>();
		add(_grpActors);
		
		_grpUI = new FlxTypedGroup<FlxSprite>();
		add(_grpUI);
		
		_grpCharacters = new FlxTypedGroup<FlxSprite>();
		
		_mechanicChar = new MechanicChar(FlxG.width * 3/4 - 48, 548);
		_grpCharacters.add(_mechanicChar);
		_grpActors.add(_mechanicChar);
		
		_robotChar = new RobotChar(FlxG.width / 4, 500);
		_grpCharacters.add(_robotChar);
		_grpActors.add(_robotChar);
		_grpBackgroundSprites.add(_robotChar.shieldGraphic);
		
		_grpEnemies = new FlxTypedGroup<FlxSprite>();
		
		_grpEnemyProj = new FlxTypedGroup<Projectile>();
		_grpPlayerProj = new FlxTypedGroup<Projectile>();
		
		_enemySpawner = new EnemySpawner();		
		
		_UiManager = new UI(_robotChar, _mechanicChar);
		add(_UiManager.uiInitialMenu);
		add(_UiManager.uiBarSprites);
		
		_scoreText = _UiManager.makeScore();
		add(_scoreText);
		_multText = _UiManager.makeMult();
		add(_multText);
		scoreState = new FSM(normScoreState);
		
		super.create();
	}
	
	private function startGame()
	{
		_UiManager.hideInitialMenu();
		_gameStarted = true;
		add(_enemySpawner);
	}
	
	public function gameOver()
	{
		FlxG.camera.flash(FlxColor.WHITE, .2);
		FlxG.camera.shake(0.01, 0.2);
		add(_UiManager.uiGameOver);
		
		_robotChar.kill();

		_gameIsOver = true;
	}
	
	public function increaseScore(points:Int):Void
	{
		playerScore += points * scoreMultiplier;
	}
	
	public function increaseMultiplier():Void
	{
		scoreState.transitionStates(increaseMultiplierTransition);
	}
	
	public function increaseMultiplierTransition():Int
	{
		scoreMultiplier++;
		scoreState.nextTransition = multiplierInactiveTransition;
		return 240;
	}
	
	public function multiplierInactiveTransition():Int
	{
		scoreMultiplier = 1;
		return -1;
	}
	
	public function normScoreState():Void
	{
		return;
	}
	
	private function sortByOffsetY(Order:Int, Obj1:FlxObject, Obj2:FlxObject):Int
	{
		return FlxSort.byValues(Order, Obj1.y + Obj1.height + (cast Obj1).offset.y, Obj2.y + Obj2.height + (cast Obj2).offset.y);
	}
	
	private function deadlyProjectileCollisions(actor:Dynamic, projectile:Projectile):Void
	{
		if(!actor.isDead)
		{
			actor.damaged(projectile.damage);
			projectile.deadlyCollide();
		}
		
	}
	
	private function shieldProjectileCollisions(shield:EnergyShield, projectile:Projectile):Void
	{
		shield.projectileCollide(projectile);
		projectile.shieldCollide();
		_robotChar.addToCapacity(projectile.force);
	}
	
	private function shieldEnemyCollisions(shield:EnergyShield, enemy:Enemy):Void
	{
		_robotChar.addToCapacity(enemy.force);
	}
	
	private function characterEnemyCollisions(character:PlayerChar, enemy:Enemy):Void
	{
		if (!character.isDead)
		{
			character.damaged(enemy.force);
			enemy.damaged(character.force);
			scoreState.transitionStates(multiplierInactiveTransition);
		}
		
	}
	

	private function separateAndRemember(Object1:FlxObject, Object2:FlxObject):Bool
	{
		if (!(cast Object2).isDead)
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
		else
			return false;
	}
	
	private function conditionalSeparate(Object1:FlxObject, Object2:FlxObject):Bool
	{
		//The following casts assume that object1 is the robot, and object2 is the mechanic.
		if ((cast Object1).wallCollideX)
			Object1.immovable = true;
		else
			Object1.immovable = false;
		
		if ((cast Object2).wallCollideX)
			Object2.immovable = true;
		else
		{
			Object1.immovable = true;
			Object2.immovable = false;
		}
		
		var separatedX:Bool = FlxObject.separateX(Object1, Object2);
		
		
		if ((cast Object1).wallCollideY)
			Object1.immovable = true;
		else
			Object1.immovable = false;
		
		if ((cast Object2).wallCollideY)
			Object2.immovable = true;
		else
		{
			Object1.immovable = true;
			Object2.immovable = false;
		}
		
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
		
		if (!_gameStarted)
		{
			if (FlxG.keys.anyPressed([W, A, S, D, UP, DOWN, LEFT, RIGHT, SPACE]))
				startGame();
		}
		else if (_gameIsOver)
		{
			if (FlxG.keys.anyPressed([R]))
			{
				Enemy.gameOverProjCleanup();
				FlxG.resetState();
			}
		}
		else if (_incScoreTimer == 0)
		{
			increaseScore(10);
			_incScoreTimer = _maxScoreTimer;
		}
		else
			_incScoreTimer--;
		
		_robotChar.immovable = true; //prevents mechanic from pushing robot around.
		FlxG.collide(_robotChar, _mechanicChar);
		_robotChar.immovable = false;
		
		//Quick Note: The order of the groups in this call matters!
		//	_grpBoundaries comes first, then _grpCharacters
		FlxG.overlap(_grpBoundaries, _grpCharacters, null, separateAndRemember);
		FlxG.overlap(_robotChar, _mechanicChar, null, conditionalSeparate);
		
		FlxG.overlap(_robotChar.shield, _grpEnemyProj, shieldProjectileCollisions);
		FlxG.overlap(_grpCharacters, _grpEnemyProj, deadlyProjectileCollisions);
		FlxG.overlap(_grpEnemies, _grpPlayerProj, deadlyProjectileCollisions);
		FlxG.overlap(_grpCharacters, _grpEnemies, characterEnemyCollisions);
		FlxG.overlap(_robotChar.shield, _grpEnemies, shieldEnemyCollisions);
		
		
		_robotChar.shield.updateProjectiles();
		
		_grpActors.sort(sortByOffsetY, FlxSort.ASCENDING);
		
		scoreState.update();
		_scoreText.text = Std.string(playerScore);
		_multText.text = "x" + Std.string(scoreMultiplier);
	}
}