package objects;

class Explosion extends FlxSprite
{

	public function new(p:FlxPoint)
	{
		super(p.x, p.y);
		loadGraphic(AssetsImg.explosion__png, true, 48, 48);
		animation.add('play', [0,1,2,3,4,5,6,7,7,8,8,9,9,9,10,10,10,11], 30, false);
		offset.set(24, 24);
		animation.play('play');
		cameras = [FlxG.camera];
		states.PlayState.i.add(this);
		FlxG.sound.play('assets/audio/explosion.ogg');
	}

	override public function update(dt:Float)
	{
		super.update(dt);
		if (animation.finished) kill();
	}

}