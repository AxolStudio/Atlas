package;

import openfl.geom.Point;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.util.FlxGradient;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.addons.display.FlxTiledSprite;
import openfl.display.BitmapData;

class PlayState extends FlxState
{

	public var bigNeighbors:Array<FlxSprite>;
	public var TileID:Int = -1;
	public var emptyImg:BitmapData;


	override public function create():Void
	{
		Connection.state = this;
		bgColor = 0xff909090;

		emptyImg = new BitmapData(64,64,false, 0x303030);

		bigNeighbors = [];

		var grids:Array<FlxTiledSprite> = [];
		var grid:FlxTiledSprite;

		var b:FlxSprite;
		for(i in 0...9)
		{
			b = new FlxSprite();
			b.makeGraphic(64,64, 0xff303030, true, "b" + Std.string(i));
			b.scale.set(10,10);
			b.updateHitbox();
			bigNeighbors.push(b);

			grid = new FlxTiledSprite(AssetPaths.grid__png,640,640);
			grids.push(grid);

		}

		bigNeighbors[0].x = (72 - 642);
		bigNeighbors[0].y = (72 - 642);
		grids[0].x = bigNeighbors[0].x;
		grids[0].y = bigNeighbors[0].y;

		bigNeighbors[1].x = 72;
		bigNeighbors[1].y = (72 - 642);
		grids[1].x = bigNeighbors[1].x;
		grids[1].y = bigNeighbors[1].y;

		bigNeighbors[2].x = (72 + 642);
		bigNeighbors[2].y = (72 - 642);
		grids[2].x = bigNeighbors[2].x;
		grids[2].y = bigNeighbors[2].y;

		bigNeighbors[3].x = (72 - 642);
		bigNeighbors[3].y = 72;
		grids[3].x = bigNeighbors[3].x;
		grids[3].y = bigNeighbors[3].y;

		bigNeighbors[4].x = 72;
		bigNeighbors[4].y = 72;
		grids[4].x = bigNeighbors[4].x;
		grids[4].y = bigNeighbors[4].y;

		bigNeighbors[5].x = (72 + 642);
		bigNeighbors[5].y = 72;
		grids[5].x = bigNeighbors[5].x;
		grids[5].y = bigNeighbors[5].y;

		bigNeighbors[6].x = (72 - 642);
		bigNeighbors[6].y = (72 + 642);
		grids[6].x = bigNeighbors[6].x;
		grids[6].y = bigNeighbors[6].y;

		bigNeighbors[7].x = 72;
		bigNeighbors[7].y = (72 + 642);
		grids[7].x = bigNeighbors[7].x;
		grids[7].y = bigNeighbors[7].y;

		bigNeighbors[8].x = (72 + 642);
		bigNeighbors[8].y = (72 + 642);
		grids[8].x = bigNeighbors[8].x;
		grids[8].y = bigNeighbors[8].y;

		add(bigNeighbors[0]);
		add(bigNeighbors[1]);
		add(bigNeighbors[2]);
		add(bigNeighbors[3]);
		add(bigNeighbors[4]);
		add(bigNeighbors[5]);
		add(bigNeighbors[6]);
		add(bigNeighbors[7]);
		add(bigNeighbors[8]);

		add(grids[0]);
		add(grids[1]);
		add(grids[2]);
		add(grids[3]);
		add(grids[4]);
		add(grids[5]);
		add(grids[6]);
		add(grids[7]);
		add(grids[8]);

		buildWhiteFrame();

		super.create();
	}

	private function buildWhiteFrame():Void
	{


		var w:FlxSprite = FlxGradient.createGradientFlxSprite(644, 20, [FlxColor.WHITE, FlxColor.TRANSPARENT], 1, 90);
		w.x = 70;
		w.y = 18;
		add(w);

		w = FlxGradient.createGradientFlxSprite(52,52,[FlxColor.WHITE, FlxColor.WHITE, FlxColor.TRANSPARENT], 1,45);
		w.x = 18;
		w.y = 18;
		add(w);

		w = FlxGradient.createGradientFlxSprite(644, 20, [FlxColor.WHITE, FlxColor.TRANSPARENT], 1, -90);
		w.y = 744;
		w.x = 70;
		add(w);

		w = FlxGradient.createGradientFlxSprite(52,52,[FlxColor.WHITE, FlxColor.WHITE, FlxColor.TRANSPARENT], 1, -45);
		w.x = 18;
		w.y = 712;
		add(w);

		w = FlxGradient.createGradientFlxSprite(20, 644, [FlxColor.WHITE, FlxColor.TRANSPARENT], 1, 0);
		w.x = 18;
		w.y = 70;
		add(w);

		w = FlxGradient.createGradientFlxSprite(20, 644, [FlxColor.WHITE, FlxColor.TRANSPARENT], 1, 180);
		w.x = 744;
		w.y = 70;
		add(w);

		w = FlxGradient.createGradientFlxSprite(52,52,[FlxColor.WHITE, FlxColor.WHITE, FlxColor.TRANSPARENT], 1,-135);
		w.x = 712;
		w.y = 712;
		add(w);

		w = FlxGradient.createGradientFlxSprite(52,52,[FlxColor.WHITE, FlxColor.WHITE, FlxColor.TRANSPARENT], 1,135);
		w.x = 712;
		w.y = 18;
		add(w);

		w = new FlxSprite(0, 0);
		w.makeGraphic(FlxG.width, 18, FlxColor.WHITE);
		add(w);

		w = new FlxSprite(0,0);
		w.makeGraphic(18, FlxG.height, FlxColor.WHITE);
		add(w);

		w = new FlxSprite(764, 0);
		w.makeGraphic(Std.int(FlxG.width - 764), FlxG.height, FlxColor.WHITE);
		add(w);

		w = new FlxSprite(0, 764);
		w.makeGraphic(FlxG.width, Std.int(FlxG.height - 764), FlxColor.WHITE);
		add(w);
	}

	public function init(TID:Int):Void
	{
		TileID = TID;
		
		for (t in bigNeighbors)
		{
			t.pixels.copyPixels(emptyImg, emptyImg.rect, new Point());
			t.dirty = true;
		}

		Connection.getNeighbors(TileID);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

@:expose
class ViewerFunctions 
{
    function new() {
        // nothing...
    }
    public function init(TileID:Int):Void
    {
        cast(FlxG.state, PlayState).init(TileID);
    }
}
