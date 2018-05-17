package;

import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;
import flixel.system.scaleModes.StageSizeScaleMode;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, PlayState, 1, 60, 60, true));
		FlxG.scaleMode = new StageSizeScaleMode();
		FlxG.mouse.useSystemCursor = true;
	}
}
