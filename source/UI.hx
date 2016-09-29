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
class UI extends FlxSprite
{
	private var _uiBarSprites:FlxTypedGroup<FlxSprite>;
	private var _bg:FlxSprite;
	private var _bar:FlxBar;
	private var _fg:FlxSprite;
	private var _barText:FlxText;
	
	public function new(?X:Float=0, ?Y:Float=0, ?parentRef:Dynamic, variable:String = "", max:Float) 
	{
		super(X, Y);
		set_visible(false);
		_uiBarSprites = new FlxTypedGroup<FlxSprite>();
		FlxG.state.add(_uiBarSprites);
		
		_bg = new FlxSprite(X-3, Y, AssetPaths.capacity_bg__png);
		_bg.set_alpha(.5);
		_uiBarSprites.add(_bg);
		
		_fg = new FlxSprite(X, Y, AssetPaths.capacity_fg__png);
		
		_bar = new FlxBar(X, Y, LEFT_TO_RIGHT, 750, 50, parentRef, variable, 0, max);
		_bar.createGradientBar([], [0xccff0000, 0xcc00ffff]); 
		_bar.numDivisions = 500;
		_uiBarSprites.add(_bar);
		
		
		_uiBarSprites.add(_fg);
		
		
		_barText = new FlxText(0, Y - 32, 0, "Shield Capacity", 16);
		_barText.x = X + 375 - _barText.width / 2;
		_uiBarSprites.add(_barText);
	}
	
}