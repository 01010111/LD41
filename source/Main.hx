package;

import flixel.FlxGame;
import openfl.display.Sprite;
import states.Title;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(200, 160, Title));
		FlxG.addPostProcess(new flixel.effects.postprocess.PostProcess(AssetsData.fisheye__frag));
	}
}
