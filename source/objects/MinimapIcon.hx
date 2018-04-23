package objects;

class MinimapIcon extends FlxSprite
{

	public var parent:FlxSprite;

	public function new(parent:FlxSprite, color:Int)
	{
		super(0, 0, AssetsImg.minimap_icon__png);
		this.parent = parent;
		this.color = color;
		offset.set(4, 4);
	}

	override public function update(dt:Float)
	{
		super.update(dt);

		var pm = parent.getMidpoint();
		pm.x = pm.x.map(0, states.PlayState.i.tiles.width, 12, 60);
		pm.y = pm.y.map(0, states.PlayState.i.tiles.height, FlxG.height - 56, FlxG.height - 8);
		this.set_position(pm);
		angle = parent.angle;
	}

}