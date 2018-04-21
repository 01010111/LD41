package util;

class CsvHandler
{

	public static function get_tilemap():Array<Array<Int>>
	{
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
				a[y][x] = t;
			}
		}
		return a;
	}

}