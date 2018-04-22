package objects;

import states.PlayState;

class ThreeDeeObject extends FlxTypedGroup<Slice>
{

	public var base:FlxSprite;
	public var offset:Float;

	var tween_time:Float = 0.5;
	var offset_amt:Float = 1.0;
	var img_size:Int;

	var shadow:Bool;

	public function new(p:FlxPoint, g:String, n:Int, shadow:Bool, outline:Bool, tween:Bool = true, size:Int = 16)
	{
		super();
		this.img_size = size;
		this.shadow = shadow;
		if (outline) for (i in 1...n) add_outline(i, p, g);
		for (i in 0...n) add_sprite(i, p, g);
		offset = 0;
		if(tween) FlxTween.tween(this, { offset: offset_amt }, tween_time, { ease: FlxEase.elasticOut });
		PlayState.i.tdo_group.add(this);

		if (base.width != 24) return;
		if (PlayState.i.tiles.overlapsPoint(base.getMidpoint().add(-24, 0))) base.angle = 180;
		if (PlayState.i.tiles.overlapsPoint(base.getMidpoint().add(24, 0))) base.angle = 0;
		if (PlayState.i.tiles.overlapsPoint(base.getMidpoint().add(0, -24))) base.angle = 270;
		if (PlayState.i.tiles.overlapsPoint(base.getMidpoint().add(0, 24))) base.angle = 90;
		base.angle += 90;
	}

	function add_outline(i:Int, p:FlxPoint, g:String)
	{
		var s = new Slice(p.x, p.y, i, this);
		s.loadGraphic(g, true, img_size, img_size);
		s.animation.frameIndex = i;
		s.scale.set();
		FlxTween.tween(s.scale, { x:1.15, y:1.15 }, tween_time, { ease: FlxEase.elasticOut });
		s.color = 0xFF000000;
		add(s);
	}

	function add_sprite(i:Int, p:FlxPoint, g:String)
	{
		var s = new Slice(p.x, p.y, i - 1, this);
		s.loadGraphic(g, true, img_size, img_size);
		s.animation.frameIndex = i;
		s.scale.set();
		FlxTween.tween(s.scale, { x:1, y:1 }, tween_time, { ease: FlxEase.elasticOut });
		
		if (i == 0 && shadow) s.alpha = 0.25;
		if (i == 1) base = s;
		FlxG.log.add(s.width);
		add(s);
	}

	public function get_d():Float return (base.getPosition().vector_angle() + FlxG.camera.angle).vector_from_angle(base.getPosition().vector_length()).y;

}

class Slice extends FlxSprite
{

	var z:Int;
	public var parent:ThreeDeeObject;

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