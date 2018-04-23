package objects;

class Bldg extends ThreeDeeObject
{

	public function new(x, y)
	{
		super(FlxPoint.get(x, y), AssetsImg.bldg__png, 16, false, false, true, 24);
		states.PlayState.i.buildings[(y / 24).floor()][(x / 24).floor()] = 1;
	}

}