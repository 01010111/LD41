package states;

import states.PlayState;

class Title extends FlxState
{

	var cam:FlxCamera;
	var can_leave:Bool = false;
	var left:Bool = false;

	override public function create()
	{
		super.create();
		bgColor = 0xFF001020;
		PlayState.add_ui_cam();
		PlayState.c = new ZPlayerController(0);
		PlayState.c.add();
		cam = PlayState.ui_cam;
		new FlxTimer().start(0.25, bandit_mayor);
		new FlxTimer().start(0.75, big_panic);
		new FlxTimer().start(1.75, little_panic);
		new FlxTimer().start(2, function(t:FlxTimer){ FlxG.sound.play('assets/audio/outllaw.ogg');});
	}

	function bandit_mayor(t:FlxTimer)
	{
		if (left) return;
		FlxG.sound.play('assets/audio/build.ogg');
		var t = new ZBitmapText(FlxG.width + 32, FlxG.height.half() - 16, Assets.getText(AssetsData.letters__txt), FlxPoint.get(7, 9), AssetsImg.font__png, FlxTextAlign.CENTER, FlxG.width, -2, -1);
		t.text = 'OUTLAW MAYOR';
		t.scale.set(1.5, 1.5);
		FlxTween.tween(t, { x: 0 }, 0.5, { ease: FlxEase.elasticOut });
		t.cameras = [cam];
		add(t);
	}

	function big_panic(t:FlxTimer)
	{
		if (left) return;
		for (i in 0...6)
		{
			var s = new FlxSprite(FlxG.width.half(), FlxG.height.half());
			s.loadGraphic(AssetsImg.title__png, true, 9, 10);
			s.offset.set(4.5, 4.5);
			s.scale.set(50, 50);
			s.alpha = 0;
			s.animation.frameIndex = i;
			new FlxTimer().start(i * 0.2, function(t:FlxTimer){
				if (left) return;
				FlxTween.tween(s.scale, { x: 20, y: 16 }, 0.15, { ease: FlxEase.quadIn });
				FlxTween.tween(s, { alpha: 1 }, 0.15, { ease: FlxEase.quadIn }).onComplete = function(t:FlxTween) {
					if (left) return;
					FlxG.sound.play('assets/audio/explosion.ogg');
					cam.shake(0.025, 0.1);
				}
				new FlxTimer().start(0.2, function(t:FlxTimer){
					if (left) return;
					FlxTween.tween(s, { alpha: 0 }, 0.1);
				});
			});
			s.cameras = [cam];
			add(s);
		}
	}

	function little_panic(t:FlxTimer)
	{
		if (left) return;
		for (i in 0...6)
		{
			var s = new FlxSprite(FlxG.width.half() + i * 20 - 50, FlxG.height.half() + 3);
			s.loadGraphic(AssetsImg.title__png, true, 9, 10);
			s.animation.frameIndex = i;
			s.scale.set();
			new FlxTimer().start(0.25.get_random(), function(t:FlxTimer){
				if (left) return;
				FlxG.sound.play('assets/audio/pop.ogg');
				FlxTween.tween(s.scale, { x: 4, y: 4 }, 0.3, { ease: FlxEase.bounceOut }).onComplete = function(t:FlxTween){
					if (left) return;
					FlxTween.tween(s.scale, { x: 3, y: 3 }, 0.5.get_random(0.25), { ease:FlxEase.bounceOut, type:FlxTween.PINGPONG });
				}
			});
			s.cameras = [cam];
			add(s);
		}
	}

	override public function update(dt:Float)
	{
		super.update(dt);
		//PlayState.i.c.get_joypad().connect();
		if ((PlayState.c.state.face.a_p || PlayState.c.state.face.x_p)) exit();
	}

	function exit()
	{
		FlxG.switchState(new PlayState());
	}

}