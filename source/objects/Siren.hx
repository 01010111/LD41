package objects;

import states.PlayState;

class Siren extends Indicator
{

	var target:FlxSprite;

	public function new(target:FlxSprite)
	{
		this.target = target;
		super();
	}

	override function tween()
	{
		arrow.scale.set(0.8, 0.8);
		shadow.scale.set(0.8, 0.8);
		FlxTween.tween(arrow.scale, { x: 0.5, y: 0.5 }, 1, { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });
		FlxTween.tween(shadow.scale, { x: 0.6, y: 0.6 }, 1, { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });
	}

	override function make_arrow()
	{
		arrow = new FlxSprite();
		arrow.loadGraphic(AssetsImg.siren__png, true, 24, 24);
		arrow.animation.add('play', [0, 1, 2, 3, 4, 5, 6], 30);
		arrow.animation.play('play');
		arrow.cameras = [FlxG.camera];
		arrow.offset.set(12, 12);
	}

	override function make_shadow()
	{
		shadow = new FlxSprite();
		shadow.loadGraphic(AssetsImg.siren__png, true, 24, 24);
		shadow.color = 0xFF000000;
		shadow.alpha = 0.33;
		shadow.cameras = [FlxG.camera];
		shadow.offset.set(12, 12);
	}

	override function update_arrow()
	{
		arrow.visible = false;
		if (target.getMidpoint().distance(PlayState.i.car.getMidpoint()) < 64) return;
		arrow.visible = true;
		var a = PlayState.i.car.getMidpoint().get_angle_between(target.getMidpoint());
		var p = PlayState.i.car.getMidpoint().place_on_circumference(a, 56);
		arrow.set_position(p);
		arrow.angle = -FlxG.camera.angle;
	}

	override function update_shadow()
	{
		shadow.visible = arrow.visible;
		var offset = ((FlxG.camera.angle + 90) * -1).vector_from_angle(-4).to_flx();
		shadow.setPosition(arrow.x + offset.x, arrow.y + offset.y);
		shadow.angle = arrow.angle;
	}

}