package objects;

class Tree extends ThreeDeeObject
{

	public function new(x:Float, y:Float)
	{
		super(FlxPoint.get(x, y), AssetsImg.tree__png, 16, true, false);
		offset_amt = 1.5;
	}

}