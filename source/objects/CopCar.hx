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
	var ai:Int;
	var ai_stage:Int;
	var init_p:IntPoint;

	public function new(x:Int, y:Int, ai:Int, speed:Float)
	{
		init_p = new IntPoint(x, y);
		this.ai = ai;
		car_speed = speed;
		super(get_spawn(x, y), AssetsImg.copcar__png, 9, true, true);
		base.drag.set(car_drag, car_drag);
		PlayState.i.cops.add(base);
		base.path = new FlxPath();
	}

	function get_spawn(i:Int, j:Int):FlxPoint
	{
		var x = i == 0 ? 0 : PlayState.i.tiles.width.half();
		var y = j == 0 ? 0 : PlayState.i.tiles.height.half();
		var p = new IntPoint();
		while (PlayState.i.tiles.overlapsPoint(FlxPoint.get(p.x * 24 + 12 + x, p.y * 24 + 12 + y))) p.set(7.get_random(1).to_int(), 7.get_random(1).to_int());
		return FlxPoint.get(p.x * 24 + 8 + x, p.y * 24 + 8 + y);
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

	override public function do_ai()
	{
		if (!PlayState.i.car.alive) go_home();
		switch (ai)
		{
			case 0: aggro();
			case 1: midgo();
			case 2: fastgo();
			default: return;
		}
	}

	function aggro(?t:FlxPath)
	{
		chase_car();
	}

	function midgo(?t:FlxPath)
	{
		switch(ai_stage)
		{
			case 0: go_toward_car();
			case 1: run_away();
			default: return;
		}
	}

	function fastgo(?t:FlxPath)
	{
		go_clockwise();
	}

	function go_toward_car(?t:FlxPath)
	{
		if (PlayState.i.car == null || !PlayState.i.car.alive) 
		{
			go_home();
			return;
		}
		var tq = get_quadrant(PlayState.i.car);
		var target = get_spawn(tq.x, tq.y);
		base.path.start(
			PlayState.i.tiles.findPath(
				base.getMidpoint(),
				target,
				false, false
			),
			car_speed
		);
		ai_stage = ai_stage == 0 ? 1 : 0;
		base.path.onComplete = midgo;
	}

	function chase_car(?p:FlxPath)
	{
		if (PlayState.i.car == null || !PlayState.i.car.alive) 
		{
			go_home();
			return;
		}
		base.path.start(
			PlayState.i.tiles.findPath(
				base.getMidpoint(),
				PlayState.i.car.getMidpoint(),
				false, false
			),
			car_speed
		);
		base.path.onComplete = chase_car;
	}

	function go_clockwise(?t:FlxPath)
	{
		if (PlayState.i.car == null || !PlayState.i.car.alive) 
		{
			go_home();
			return;
		}
		var tq = get_quadrant_cw(get_quadrant());
		var target = get_spawn(tq.x, tq.y);
		base.path.start(
			PlayState.i.tiles.findPath(
				base.getMidpoint(),
				target,
				false, false
			),
			car_speed
		);
		base.path.onComplete = go_clockwise;
	}

	function get_quadrant(?o:FlxObject):IntPoint
	{
		if (o == null) o = base;
		var p = new IntPoint(0, 0);
		if (o.x > PlayState.i.tiles.width.half()) p.x = 1;
		if (o.y > PlayState.i.tiles.height.half()) p.y = 1;
		return p;
	}

	function get_quadrant_cw(p:IntPoint):IntPoint
	{
		var c = new IntPoint();
		p.y == 0 ? p.x == 0 ? c.set(1, 0) : c.set(1, 1) : p.x == 0 ? c.set(0, 0) : c.set(0, 1);
		return c;
	}

	function run_away(?t:FlxPath)
	{
		if (PlayState.i.car == null || !PlayState.i.car.alive) 
		{
			go_home();
			return;
		}
		var tq = get_quadrant_cw(get_quadrant_cw(get_quadrant(PlayState.i.car)));
		var target = get_spawn(tq.x, tq.y);
		base.path.start(
			PlayState.i.tiles.findPath(
				base.getMidpoint(),
				target,
				false, false
			),
			car_speed
		);
		ai_stage = ai_stage == 0 ? 1 : 0;
		base.path.onComplete = midgo;
	}

	function go_home()
	{
		var target = get_spawn(init_p.x, init_p.y);
		base.path.start(
			PlayState.i.tiles.findPath(
				base.getMidpoint(),
				target,
				false, false
			),
			80
		);
		base.path.onComplete = null;
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