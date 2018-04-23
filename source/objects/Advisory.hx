package objects;

import states.PlayState;

class Advisory extends FlxGroup
{

	var man:FlxSprite;
	var bubble:FlxSprite;
	var request:ZBitmapText;
	var up:Bool = false;
	var talking:Bool = false;

	public function new()
	{
		super();

		man = new FlxSprite(FlxG.width - 28, FlxG.height + 24);
		man.loadGraphic(AssetsImg.advisor__png, true, 24, 24);
		man.animation.add('talk', [1, 2, 3, 4, 5, 4, 3, 2, 1, 2, 3, 4, 5, 4, 3, 2, 1, 2, 3, 4, 5, 4, 3, 2, 1, 2, 3, 4, 5, 4, 3, 2, 0, 2, 3, 4, 5, 4, 3, 2], 30);
		man.animation.play('talk');
		
		bubble = new FlxSprite(FlxG.width - 128, FlxG.height + 40, AssetsImg.bubble__png);

		request = new ZBitmapText(FlxG.width - 128, FlxG.height + 40, 'TRBHFUD901', FlxPoint.get(24, 31), AssetsImg.object_icons__png, FlxTextAlign.CENTER, 100);

		add(man);
		add(bubble);
		add(request);

		man.angle = -5;
		FlxTween.tween(man.scale, { x: 1.2, y: 1.2 }, 0.5, { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });
		FlxTween.tween(man, { angle: 5 }, 0.75, { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });

		bubble.angle = -5;
		FlxTween.tween(bubble.scale, { x: 0.8, y: 0.8 }, 0.75, { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });
		FlxTween.tween(bubble, { angle: 5 }, 2, { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });

		request.angle = -4;
		request.scale.set(0.75, 0.75);
		FlxTween.tween(request.scale, { x: 0.6, y: 0.6 }, 0.75, { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });
		FlxTween.tween(request, { angle: 4 }, 2, { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });

		for (o in this) o.cameras = [PlayState.ui_cam];
	}

	override public function update(dt:Float)
	{
		super.update(dt);

		if (PlayState.i.placing && !up || talking)
		{
			up = true;
			FlxG.sound.play('assets/audio/buildit.ogg');
			FlxTween.tween(man, { y: FlxG.height - 28 }, 0.5, { ease: FlxEase.elasticOut });
			FlxTween.tween(bubble, { y: FlxG.height - 40 }, 0.75, { ease: FlxEase.elasticOut });
			FlxTween.tween(request, { y: FlxG.height - 36 }, 0.8, { ease: FlxEase.elasticOut });
		}
		else if (!PlayState.i.placing && up)
		{
			up = false;
			FlxTween.tween(man, { y: FlxG.height + 28 }, 0.5, { ease: FlxEase.backIn });
			FlxTween.tween(bubble, { y: FlxG.height + 40 }, 0.75, { ease: FlxEase.backIn });
			FlxTween.tween(request, { y: FlxG.height + 40 }, 0.8, { ease: FlxEase.backIn });
		}

		var t1 = switch (PlayState.i.place_type)
		{
			case 0: 'R';
			case 1: 'B';
			case 2: 'H';
			case 3: 'F';
			default: '';
		}
		var t2 = switch (PlayState.i.neighbor_type)
		{
			case 0: 'R';
			case 1: 'B';
			case 2: 'H';
			case 3: 'F';
			case 4: 'T';
			default: '';
		}
		if (up) request.text = PlayState.i.score < 500 ? '$t1' : '$t1${PlayState.i.relationship_type}$t2';
	}

}