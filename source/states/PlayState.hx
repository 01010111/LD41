package states;

class PlayState extends FlxState
{

	var car:FlxSprite;
	var controller:ZPlayerController;
	var tiles:FlxTilemap;

	override public function create():Void
	{
		super.create();

		bgColor = 0xFF00a093;

		tiles = new FlxTilemap();
		tiles.loadMapFrom2DArray(util.CsvHandler.get_tilemap(), AssetsImg.tiles__png, 24, 24, null, 0, 0, 0);
		tiles.cameras = [FlxG.camera];
		for (i in 4...20) tiles.setTileProperties(i, 0x0000);
		add(tiles);

		var player_car = new objects.Car(50, 50);
		car = player_car.base;
		add(player_car);

		var cop_car = new objects.ThreeDeeObject(FlxPoint.get(200, 200), AssetsImg.copcar__png, 9, true);
		add(cop_car);

		controller = new ZPlayerController(0);
		controller.add();

		FlxG.camera.setSize(FlxG.width * 2, FlxG.height * 2);
		FlxG.camera.setPosition(-FlxG.width.half(), -FlxG.height.half());
		FlxG.camera.follow(car);
		FlxG.camera.setScrollBoundsRect(-1000, -1000, tiles.width + 2000, tiles.height + 2000, true);

		var ui_cam = new flixel.FlxCamera();
		ui_cam.bgColor = 0x00FFFFFF;
		FlxG.cameras.add(ui_cam);

		var test = new FlxText(128, 128, 100, "HI");
		test.scrollFactor.set();
		test.cameras = [ui_cam];
		add(test);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		FlxG.collide(tiles, car);
	}

}
