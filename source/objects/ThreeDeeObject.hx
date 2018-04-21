package objects;

class ThreeDeeObject extends FlxTypedGroup<Slice>
{

	public var base:FlxSprite;
	public var offset:Float = 1;

	var shadow:Bool;

	public function new(p:FlxPoint, g:String, n:Int, shadow:Bool)
	{
		super();
		this.shadow = shadow;
		for (i in 1...n) add_outline(i, p, g);
		for (i in 0...n) add_sprite(i, p, g);
	}

	function add_outline(i:Int, p:FlxPoint, g:String)
	{
		var s = new Slice(p.x, p.y, i, this);
		s.loadGraphic(g, true, 16, 16);
		s.animation.frameIndex = i;
		s.scale.set(1.15, 1.15);
		s.color = 0xFF000000;
		add(s);
	}

	function add_sprite(i:Int, p:FlxPoint, g:String)
	{
		var s = new Slice(p.x, p.y, i - 1, this);
		s.loadGraphic(g, true, 16, 16);
		s.animation.frameIndex = i;
		
		if (i == 0 && shadow) s.alpha = 0.25;
		if (i == 1) base = s;

		add(s);
	}

	function get_y():Float return base.getMidpoint().y;

}

class Slice extends FlxSprite
{

	var z:Int;
	var parent:ThreeDeeObject;

	public function new(x:Float, y:Float, z:Int, parent:ThreeDeeObject)
	{
		super(x, y);
		this.z = z;
		this.parent = parent;
		cameras = [FlxG.camera];
	}

	override public function update(e:Float)
	{
		if (this != parent.base) slave_to_base();
		super.update(e);
	}

	function slave_to_base()
	{
		var offset = ((FlxG.camera.angle + 90) * -1).vector_from_angle(z * parent.offset).to_flx();
		setPosition(parent.base.x + offset.x, parent.base.y + offset.y);
		angle = parent.base.angle;
	}

}