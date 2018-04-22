package util;

class CsvHandler
{

	public static var available_points:Array<IntPoint>;

	public static function get_tilemap():Array<Array<Int>>
	{
		available_points = [];
		var string = Assets.getText(AssetsData.tiles__csv);
		var tiles_array = string.csv_to_2d_int_array();
		var a = [];
		for (y in 0...tiles_array.length)
		{
			a[y] = [];
			for (x in 0...tiles_array[y].length)
			{
				var t = 4;
				if (tiles_array[y][x] == 0) t = 4.get_random().to_int();
				else 
				{
					if (y > 0 && tiles_array[y - 1][x] > 0) t += 1;
					if (y < tiles_array.length && tiles_array[y + 1][x] > 0) t += 2;
					if (x > 0 && tiles_array[y][x - 1] > 0) t += 4;
					if (x < tiles_array[y].length && tiles_array[y][x + 1] > 0) t += 8;
				}
				if (t < 4) check_for_point(tiles_array, x, y);
				a[y][x] = t;
			}
		}

		available_points.shuffle();
		
		return a;
	}

	static function check_for_point(a:Array<Array<Int>>, x:Int, y:Int)
	{
		if (
			y > 0 && a[y - 1][x] > 0 ||
			y < a.length - 1 && a[y + 1][x] > 0 ||
			x > 0 && a[y][x - 1] > 0 ||
			x < a[0].length - 1 && a[y][x + 1] > 0
		) available_points.push(new IntPoint(x, y));
	}

	public static function get_available_points():Array<FlxPoint>
	{
		var a = [];
		return [for (ip in available_points) FlxPoint.get(ip.x * 24 + 12, ip.y * 24 + 12)];
	}

}