package states;

import objects.*;
import objects.ThreeDeeObject.Slice;

class PlayState extends ZState
{

	public static var i:PlayState;

	public var ui_cam:FlxCamera;
	public var c:ZPlayerController;
	public var car:Slice;
	public var tiles:FlxTilemap;
	public var tdo_group:TDOGroup;
	public var objective:CheckPoint;
	public var available_points:Array<FlxPoint>;
	public var closest_point:FlxPoint;
	public var selection:Selection;
	public var placing:Bool = false;
	public var place_type:Int;
	public var neighbor_type:Int;
	public var relationship_type:Int;
	public var score:Int = 0;
	public var display_score:Float = 0;
	public var score_text:ZBitmapText;
	public var cops:FlxTypedGroup<Slice>;
	public var buildings:Array<Array<Int>>;
	public var thumbs:ZBitmapText;
	public var lives:Int = 3;
	public var lives_spr:Array<FlxSprite> = [];
	
	var done:Bool = false;

	override public function create():Void
	{
		super.create();
		bgColor = 0xFF00a093;

		i = this;

		buildings = [ for (i in 0...16) [ for (i in 0...16) 0 ] ];
		cops = new FlxTypedGroup();

		add_ui_cam();
		add_tiles();
		add_groups();

		add_cop_car(1, 0, 2, 80);
		add_cop_car(1, 1, 1, 60);
		add_cop_car(0, 1, 0, 40);
		add_car();

		selection = new Selection();

		for (i in 0...20) add_tree(available_points.pop());
		for (i in 0...6) add_house(available_points.pop());
		for (i in 0...4) add_building(available_points.pop());
		for (i in 0...2) add_hospital(available_points.pop());
		for (i in 0...2) add_firestation(available_points.pop());
		add_tower(available_points.pop());

		init_camera();

		add_ui();

		place_objective(tiles.width.half(), tiles.height.half());

		FlxG.camera.angle = 45;
		ui_cam.active = false;
		openSubState(new Title());
	}

	function add_car()
	{
		new objects.Car(24 * 3 + 4, 24 * 4 + 4);
		for (cop in cops) cop.parent.do_ai();
		FlxG.camera.follow(car);
	}

	function add_cop_car(i:Int, j:Int, ai:Int, speed:Float)
	{
		new objects.CopCar(i, j, ai, speed);
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
		for (cop in cops) add(new Siren(cop));
		add(new Indicator());
		score_text = new ZBitmapText(0, 10, Assets.getText(AssetsData.letters__txt), FlxPoint.get(7, 9), AssetsImg.font__png, FlxTextAlign.CENTER, FlxG.width);
		add_ui_element(score_text);
		make_minimap();
		add_ui_element(new Advisory());
		thumbs = new ZBitmapText(0, 16, 'TRBHFUD901', FlxPoint.get(24, 31), AssetsImg.object_icons__png, FlxTextAlign.CENTER, FlxG.width);
		thumbs.scale.set();
		add_ui_element(thumbs);
		for (i in 0...lives)
		{
			var s = new FlxSprite(4 + 18 * i, 8);
			s.loadGraphic(AssetsImg.lives__png, true, 24, 16);
			FlxTween.tween(s.scale, { x: 1.2, y: 1.2 }, 2.get_random(1), { ease: FlxEase.bounceOut, type: FlxTween.PINGPONG });
			add_ui_element(s);
			lives_spr.push(s);
		}
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
		for (cop in cops) add_ui_element(new MinimapIcon(cop, 0xFF0040ff));
	}

	function place_objective(x:Float = -1, y:Float = -1)
	{
		if (x == -1 || y == -1)
		{
			x = car.x > tiles.width.half() ? 0 : tiles.width.half();
			y = car.y > tiles.height.half() ? 0 : tiles.height.half();
		}
		var p = new IntPoint();
		while (tiles.overlapsPoint(FlxPoint.get(p.x * 24 + 12 + x, p.y * 24 + 12 + y))) p.set(7.get_random(1).to_int(), 7.get_random(1).to_int());
		objective = new objects.CheckPoint(p.x * 24 + 4 + x, p.y * 24 + 4 + y);
	}

	public function add_ui_element(o:FlxBasic)
	{
		o.cameras = [ui_cam];
		add(o);
	}

	override public function update(elapsed:Float):Void
	{
		if (!ui_cam.active) ui_cam.active = true;
		super.update(elapsed);
		if (done && (c.state.face.a_p || c.state.face.x_p)) FlxG.resetState();
		FlxG.collide(tiles, car);
		FlxG.overlap(cops, car, wasted);
		FlxG.overlap(objective.base, car, get_objective);
		set_closest_point();
		place_object();
		update_ui();
	}

	public function wasted(cop:Slice, car:Slice)
	{
		for (i in 0...5)
		{
			new FlxTimer().start(i * 0.15, function (t:FlxTimer) {
				add(new Explosion(car.getMidpoint().add(8.get_random(), 8.get_random())));
			});
		}
		car.parent.kill();
		for (cop in cops) cop.parent.do_ai();
		if (lives > 0)
		{
			lives--;
			lives_spr[lives].animation.frameIndex = 1;
			new FlxTimer().start(1.5).onComplete = function (t:FlxTimer) { add_car(); }
		}
		else
		{
			done = true;
			for (i in 0...100) new FlxTimer().start(i * 0.3, function(t:FlxTimer) { make_game_over_text(); });
		}
	}

	function make_game_over_text()
	{
		var t = ['BAD DRIVER +1', 'GAME OVER', 'YOU BLEW IT', 'YOU STINK', 'NICE JOB', 'GO FRICK URSELF', 'WOW', 'LITERALLY THE WORST', 'GO AWAY', 'GIVE UP VIDEO GAMES'].get_random();
		var c = [0xfffc301d, 0xffff7e2b, 0xffffc702, 0x760046, 0xff59ff9b, 0xff00a093, 0xff4ba8ff, 0xffb1d61b, 0xff13b517].get_random();
		var text = new ZBitmapText(0.get_random(0, FlxG.width - 64), FlxG.height.get_random(0), Assets.getText(AssetsData.letters__txt), FlxPoint.get(7, 9), AssetsImg.font__png, FlxTextAlign.CENTER, 64, -2, -1);
		text.text = t;
		text.color = c;
		add_ui_element(text);
		FlxG.sound.play('assets/audio/pop.ogg');
		text.scale.set();
		text.angle = 0.get_random(-15, 15);
		FlxTween.tween(text.scale, { x: 2, y: 2 }, 0.5, { ease: FlxEase.elasticOut });
		FlxTween.tween(text, { angle: -text.angle.get_random() }, 3.get_random(2), { ease: FlxEase.sineInOut, type: FlxTween.PINGPONG });
	}

	function make_winning_text(i:Int)
	{
		var cs = [0xfffc301d, 0xffff7e2b, 0xffffc702, 0x760046, 0xff59ff9b, 0xff00a093, 0xff4ba8ff, 0xffb1d61b, 0xff13b517];
		cs.shuffle();
		var c = cs[i % cs.length];
		var text = new ZBitmapText(0, (i * 16) % FlxG.height, Assets.getText(AssetsData.letters__txt), FlxPoint.get(7, 9), AssetsImg.font__png, FlxTextAlign.CENTER, FlxG.width, -2, -1);
		text.text = 'SCORE: $score';
		text.color = c;
		add_ui_element(text);

		text.scale.set();
		text.angle = 0.get_random(-3, 3);
		FlxTween.tween(text.scale, { x: 2, y: 2 }, 0.5, { ease: FlxEase.elasticOut });

		var e = new Explosion(FlxPoint.get(FlxG.width.get_random(), FlxG.height.get_random()));
		var es = 3.get_random(1);
		e.scale.set(es, es);
		e.angle = 360.get_random();
		add_ui_element(e);
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
			FlxG.sound.play('assets/audio/build.ogg');
			switch (place_type)
			{
				case 0: add_house(closest_point);
				case 1: add_building(closest_point);
				case 2: add_hospital(closest_point);
				case 3: add_firestation(closest_point);
			}
			available_points.remove(closest_point);
			var m = score < 500 ? 1 : get_neighbors(new IntPoint((closest_point.x / 24).floor(), (closest_point.y / 24).floor()));
			closest_point.set();
			placing = false;
			if (available_points.length > 0) place_objective();
			score += 150 * m;
			if (m == 0) 
			{
				FlxG.sound.play('assets/audio/pop.ogg');
				thumbs.text = 'D';
				FlxTween.tween(thumbs.scale, { x: 1, y: 1 }, 0.5, { ease: FlxEase.elasticOut });
				FlxTween.tween(thumbs.scale, { x: 0, y: 0 }, 0.5, { ease: FlxEase.backIn, startDelay: 1.5 });
				return;
			}
			score_text.scale.set(3, 3);
			FlxTween.tween(score_text.scale, { x: 2, y: 2 }, 0.5, { ease: FlxEase.elasticOut });
			if (m == 1) return;
			FlxG.sound.play('assets/audio/pop.ogg');
			thumbs.text = 'U';
			FlxTween.tween(thumbs.scale, { x: 1, y: 1 }, 0.5, { ease: FlxEase.elasticOut });
			FlxTween.tween(thumbs.scale, { x: 0, y: 0 }, 0.5, { ease: FlxEase.backIn, startDelay: 1.5 });
			if (available_points.length > 0) return;
			var s = new FlxSprite();
			s.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
			s.alpha = 0;
			add_ui_element(s);
			FlxTween.tween(s, { alpha: 1 }, 1);
			for (cop in cops)
			{
				add(new Explosion(cop.getMidpoint()));
				cop.kill();
			}
			done = true;
			for (i in 0...100) new FlxTimer().start(i * 0.1, function(t:FlxTimer){ make_winning_text(i); });
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
		place_type = 4.get_random().floor();
		neighbor_type = 5.get_random().floor();
		relationship_type = 1.get_random().round();
	}

	function get_neighbors(p:IntPoint):Int
	{
		var n = 1;
		if (p.y > 0 && buildings[p.y - 1][p.x] == neighbor_type) n++;
		if (p.y < 15 && buildings[p.y + 1][p.x] == neighbor_type) n++;
		if (p.x > 0 && buildings[p.y][p.x - 1] == neighbor_type) n++;
		if (p.x < 15 && buildings[p.y][p.x + 1] == neighbor_type) n++;
		if (n > 1) n *= relationship_type;
		return n;
	}

}
