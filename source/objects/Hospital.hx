package objects;

class Hospital extends ThreeDeeObject
{

	public function new(x, y)
	{
		super(FlxPoint.get(x, y), AssetsImg.hospital__png, 12, false, false, true, 24);
		states.PlayState.i.buildings[(y / 24).floor()][(x / 24).floor()] = 2;
	}

}