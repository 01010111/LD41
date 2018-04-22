package objects;

class Tower extends ThreeDeeObject
{

	public function new(x:Float, y:Float)
	{
		super(FlxPoint.get(x, y), AssetsImg.tower__png, 24, false, false, true, 24);
		offset_amt = 1.5;
	}

}