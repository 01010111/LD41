package objects;

import states.PlayState;

class Car extends ThreeDeeObject
{

	var c:ZPlayerController;

	var turn_speed:Float = 5;
	var car_speed:Float = 80;
	var car_drag:Float = 500;
	var cam_lerp:Float = 0.033;

	public function new(x, y)
	{
		super(FlxPoint.get(x, y), AssetsImg.car__png, 9, true, true);
		c = new ZPlayerController(0);
		c.add();
		base.angle = -90;
		base.drag.set(car_drag, car_drag);
		PlayState.i.car = base;
		PlayState.i.c = c;
	}

	override public function update(dt:Float)
	{
		if (c.state.dpad.l) base.angle -= turn_speed;
		if (c.state.dpad.r) base.angle += turn_speed;
		base.velocity.copyFrom(base.angle.vector_from_angle(c.state.face.a ? car_speed * 1.5 : car_speed).to_flx());

		FlxG.camera.angle += (-base.angle - 90 - FlxG.camera.angle) * cam_lerp;

		super.update(dt);
	}

}