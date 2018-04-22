package objects;

import states.PlayState;

class CheckPoint extends ThreeDeeObject
{

	public function new(x:Float, y:Float)
	{
		super(FlxPoint.get(x, y), AssetsImg.checkpoint__png, 6, false, false, false);
		offset = 3;
		FlxTween.tween(this, { offset: 8 }, 1, { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });
	}

}