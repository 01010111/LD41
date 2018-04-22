package objects;

import objects.ThreeDeeObject.Slice;

class Selection extends ThreeDeeObject
{

	public function new()
	{
		super(FlxPoint.get(), AssetsImg.selection__png, 4, false, false, false, 24);
		offset = 1;
		FlxTween.tween(this, { offset: 4 }, 1.2, { ease:FlxEase.sineInOut, type: FlxTween.PINGPONG });
	}

	override function add_sprite(i:Int, p:FlxPoint, g:String)
	{
		var s = new Slice(p.x, p.y, i - 1, this);
		s.loadGraphic(g, true, img_size, img_size);
		s.animation.frameIndex = i;
		if (i == 3)
		{
			s.animation.add('play', [3, 4, 5, 6, 7], 30);
			s.animation.play('play');
			s.scale.set(0.75, 0.75);
			FlxTween.tween(s.scale, { x: 1.25, y: 1.25 }, 1, { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });
		}
		if (i == 1) base = s;
		FlxG.log.add(s.width);
		add(s);
	}
	
}