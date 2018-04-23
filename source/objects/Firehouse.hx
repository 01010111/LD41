package objects;

class Firehouse extends ThreeDeeObject
{

	public function new(x, y)
	{
		super(FlxPoint.get(x, y), AssetsImg.firehouse__png, 10, false, false, true, 24);
		states.PlayState.i.buildings[(y / 24).floor()][(x / 24).floor()] = 3;
	}

}