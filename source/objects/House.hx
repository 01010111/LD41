package objects;

class House extends ThreeDeeObject
{

	public function new(x, y)
	{
		super(FlxPoint.get(x, y), AssetsImg.house__png, 9, false, false, true, 24);
		states.PlayState.i.buildings[(y / 24).floor()][(x / 24).floor()] = 0;
	}

}