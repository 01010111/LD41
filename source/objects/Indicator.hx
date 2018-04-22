package objects;

import states.PlayState;

class Indicator extends FlxGroup
{

	public var arrow:FlxSprite;
	public var shadow:FlxSprite;

	public function new()
	{
		super();

		arrow = new FlxSprite();
		arrow.loadGraphic(AssetsImg.indicator__png, true, 32, 32);
		arrow.animation.add('play', [0, 1, 2, 3, 4, 5], 24);
		arrow.animation.play('play');
		arrow.cameras = [FlxG.camera];
		arrow.offset.set(16, 16);

		shadow = new FlxSprite();
		shadow.loadGraphic(AssetsImg.indicator__png, true, 32, 32);
		shadow.color = 0xFF000000;
		shadow.alpha = 0.33;
		shadow.cameras = [FlxG.camera];
		shadow.offset.set(16, 16);

		FlxTween.tween(arrow.scale, { x: 0.75, y: 0.75 }, 1, { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });
		FlxTween.tween(shadow.scale, { x: 0.8, y: 0.8 }, 1, { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });

		add(shadow);
		add(arrow);
	}

	override public function update(dt:Float)
	{
		super.update(dt);
		update_arrow();
		update_shadow();
	}

	function update_arrow()
	{
		arrow.visible = false;
		if (PlayState.i.placing || PlayState.i.objective.base.getMidpoint().distance(PlayState.i.car.getMidpoint()) < 64) return;
		arrow.visible = true;
		var a = PlayState.i.car.getMidpoint().get_angle_between(PlayState.i.objective.base.getMidpoint());
		var p = PlayState.i.car.getMidpoint().place_on_circumference(a, 48);
		arrow.set_position(p);
		arrow.angle = a;
	}

	function update_shadow()
	{
		shadow.visible = arrow.visible;
		var offset = ((FlxG.camera.angle + 90) * -1).vector_from_angle(-4).to_flx();
		shadow.setPosition(arrow.x + offset.x, arrow.y + offset.y);
		shadow.angle = arrow.angle;
	}

}