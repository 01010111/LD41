package objects;

import flixel.util.FlxPath;
import states.PlayState;
import objects.ThreeDeeObject.Slice;

class CopCar extends ThreeDeeObject
{

	var turn_speed:Float = 5;
	var car_speed:Float = 80;
	var car_drag:Float = 500;
	var cam_lerp:Float = 0.033;

	public function new(x, y)
	{
		super(FlxPoint.get(x, y), AssetsImg.copcar__png, 9, true, true);
		base.drag.set(car_drag, car_drag);
		new FlxTimer().start(0.5.get_random(0.25), path_to_car, 0);
		PlayState.i.cops.push(base);
	}

	override function add_sprite(i:Int, p:FlxPoint, g:String)
	{
		var s = new Slice(p.x, p.y, i - 1, this);
		s.loadGraphic(g, true, img_size, img_size);
		s.animation.add('play', [8, 9, 10, 10, 10, 11, 11], 15);
		i == 8 ? s.animation.play('play') : s.animation.frameIndex = i;
		s.scale.set();
		FlxTween.tween(s.scale, { x:1, y:1 }, tween_time, { ease: FlxEase.elasticOut });
		
		if (i == 0 && shadow) s.alpha = 0.25;
		if (i == 1) base = s;
		FlxG.log.add(s.width);
		add(s);
	}

	function path_to_car(t:FlxTimer)
	{
		if (base.path == null) base.path = new FlxPath();
		base.path.start(
			PlayState.i.tiles.findPath(
				base.getMidpoint(),
				PlayState.i.car.getMidpoint(),
				false, false
			),
			70
		);
	}

	override public function update(dt:Float)
	{
		super.update(dt);
		var angle = base.angle.get_relative_degree();
		var target_angle = base.velocity.vector_angle();
		if ((target_angle - angle).abs() > (target_angle - (angle - 360)).abs()) angle -= 360;
		if (base.velocity.x.abs() > 0 || base.velocity.y.abs() > 0) base.angle += (target_angle - angle) * 0.2;
	}

}