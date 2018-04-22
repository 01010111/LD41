package states;

import objects.*;
import objects.ThreeDeeObject.Slice;

class PlayState extends ZState
{

	public static var i:PlayState;

	public var ui_cam:FlxCamera;
	public var c:ZPlayerController;
	public var car:FlxSprite;
	public var tiles:FlxTilemap;
	public var tdo_group:TDOGroup;
	public var objective:CheckPoint;
	public var available_points:Array<FlxPoint>;
	public var closest_point:FlxPoint;
	public var selection:Selection;
	public var placing:Bool = false;
	public var place_type:Int;
	public var score:Int = 0;
	public var display_score:Float = 0;
	public var score_text:ZBitmapText;
	public var cops:Array<FlxSprite> = [];

	override public function create():Void
	{
		super.create();
		bgColor = 0xFF00a093;

		i = this;

		add_ui_cam();
		add_tiles();
		add_groups();

		var player_car = new objects.Car(24 * 3 + 4, 24 * 4 + 4);
		add_cop_car(1, 0);
		add_cop_car(0, 1);
		add_cop_car(1, 1);

		selection = new Selection();

		for (i in 0...20) add_tree(available_points.pop());
		for (i in 0...6) add_house(available_points.pop());
		for (i in 0...4) add_building(available_points.pop());
		for (i in 0...2) add_hospital(available_points.pop());
		for (i in 0...2) add_firestation(available_points.pop());
		add_tower(available_points.pop());

		init_camera();

		add_ui();

		place_objective();
	}

	function add_cop_car(i:Int, j:Int)
	{
		var x = i == 0 ? 0 : tiles.width.half();
		var y = j == 0 ? 0 : tiles.height.half();
		var p = new IntPoint();
		while (tiles.overlapsPoint(FlxPoint.get(p.x * 24 + 12 + x, p.y * 24 + 12 + y))) p.set(7.get_random(1).to_int(), 7.get_random(1).to_int());
		var copcar = new objects.CopCar(p.x * 24 + 8 + x, p.y * 24 + 8 + y);
	}

	function add_tree(p:FlxPoint) new objects.Tree(p.x - 8, p.y - 8);
	function add_house(p:FlxPoint) new objects.House(p.x - 12, p.y - 12);
	function add_building(p:FlxPoint) new objects.Bldg(p.x - 12, p.y - 12);
	function add_hospital(p:FlxPoint) new objects.Hospital(p.x - 12, p.y - 12);
	function add_firestation(p:FlxPoint) new objects.Firehouse(p.x - 12, p.y - 12);
	function add_tower(p:FlxPoint) new objects.Tower(p.x - 12, p.y - 12);

	function add_ui_cam()
	{
		ui_cam = new FlxCamera();
		ui_cam.bgColor = 0x00FFFFFF;
		FlxG.cameras.add(ui_cam);
	}

	function add_tiles()
	{
		tiles = new FlxTilemap();
		tiles.loadMapFrom2DArray(util.CsvHandler.get_tilemap(), AssetsImg.tiles__png, 24, 24, null, 0, 0, 0);
		tiles.cameras = [FlxG.camera];
		for (i in 4...20) tiles.setTileProperties(i, 0x0000);
		add(tiles);
		available_points = util.CsvHandler.get_available_points();
	}

	function add_groups()
	{
		tdo_group = new TDOGroup();
		add(tdo_group);
	}

	function init_camera()
	{
		FlxG.camera.setSize(FlxG.width * 2, FlxG.height * 2);
		FlxG.camera.setPosition(-FlxG.width.half(), -FlxG.height.half());
		FlxG.camera.follow(car);
		FlxG.camera.setScrollBoundsRect(-1000, -1000, tiles.width + 2000, tiles.height + 2000, true);
	}

	function add_ui()
	{
		add(new Indicator());
		score_text = new ZBitmapText(0, 10, Assets.getText(AssetsData.letters__txt), FlxPoint.get(7, 9), AssetsImg.font__png, FlxTextAlign.CENTER, FlxG.width);
		add_ui_element(score_text);
		make_minimap();
	}

	function make_minimap()
	{
		var minimap = new FlxSprite(20, FlxG.height - 48, AssetsImg.minimap__png);
		minimap.scale.set(1.45, 1.45);
		FlxTween.tween(minimap.scale, { x: 1.55, y: 1.55 }, 2, { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });

		var minimap_shadow = new FlxSprite(20, FlxG.height - 44, AssetsImg.minimap__png);
		minimap_shadow.scale.set(1.4, 1.4);
		minimap_shadow.color = 0xFF000000;
		minimap_shadow.alpha = 0.33;

		add_ui_element(minimap_shadow);
		add_ui_element(minimap);

		add_ui_element(new MinimapIcon(car, 0xFFfc301d));
		for (i in 0...cops.length) add_ui_element(new MinimapIcon(cops[i], 0xFF0040ff));
	}

	function place_objective()
	{
		var x = car.x > tiles.width.half() ? 0 : tiles.width.half();
		var y = car.y > tiles.height.half() ? 0 : tiles.height.half();
		var p = new IntPoint();
		while (tiles.overlapsPoint(FlxPoint.get(p.x * 24 + 12 + x, p.y * 24 + 12 + y))) p.set(7.get_random(1).to_int(), 7.get_random(1).to_int());
		objective = new objects.CheckPoint(p.x * 24 + 4 + x, p.y * 24 + 4 + y);
	}

	public function add_ui_element(o:FlxObject)
	{
		o.cameras = [ui_cam];
		add(o);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(tiles, car);
		FlxG.overlap(objective.base, car, get_objective);
		set_closest_point();
		place_object();
		update_ui();
	}

	public function set_closest_point()
	{
		if (closest_point == null) closest_point = FlxPoint.get();
		var d = closest_point.distance(car.getMidpoint());
		for (p in available_points) 
		{
			var d2 = p.distance(car.getMidpoint());
			if (d2 < d) closest_point = p;
		}
		selection.base.setPosition(closest_point.x - 12, closest_point.y - 12);
		selection.visible = placing;
	}

	function place_object()
	{
		if (!placing) return;
		if (c.state.face.x_p)
		{
			switch (place_type)
			{
				case 0: add_house(closest_point);
				case 1: add_building(closest_point);
				case 2: add_hospital(closest_point);
				case 3: add_firestation(closest_point);
			}
			available_points.remove(closest_point);
			closest_point.set();
			placing = false;
			place_objective();
			score += 150;
			score_text.scale.set(3, 3);
			FlxTween.tween(score_text.scale, { x: 2, y: 2 }, 0.5, { ease: FlxEase.elasticOut });
		}
	}

	public function update_ui()
	{
		score_text.text = '${display_score.ceil()}';
		display_score += (score - display_score) * 0.1;
		score_text.color = '${display_score.ceil()}' == '$score' ? 0xFFFFFFFF : [0xFFffc702, 0xFFfc301d, 0xFF59ff9b, 0xFF00a093].get_random();
	}

	public function get_objective(c:Slice, o:Slice)
	{
		for (obj in c.parent)
		{
			obj.allowCollisions = 0;
			FlxTween.tween(obj.scale, { x: 10, y: 10 }, 0.2);
			FlxTween.tween(obj, { alpha: 0 }, 0.2);
		}
		new FlxTimer().start(0.21).onComplete = function (t:FlxTimer) {
			c.parent.kill();
		}
		placing = true;
		place_type = 4.get_random().to_int();
	}

}
