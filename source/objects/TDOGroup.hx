package objects;

class TDOGroup extends FlxTypedGroup<ThreeDeeObject>
{

	public function new()
	{
		super();
	}

	override public function update(dt:Float)
	{
		super.update(dt);
		sort(sort_by_rot_y, 1);
	}

	function sort_by_rot_y(o:Int, o1:ThreeDeeObject, o2:ThreeDeeObject):Int
	{
		if (!o1.active || !o2.active) return 0;
		return o1.get_d() > o2.get_d() ? 1 : -1;
	}

}