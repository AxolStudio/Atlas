package;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tile.FlxTileblock;
import flixel.FlxSprite;
import flixel.FlxState;
import flash.display.BitmapData;
import flixel.tile.FlxTilemap;
using flixel.util.FlxSpriteUtil;
import flixel.math.FlxMath;
import js.Browser.window;
import flixel.util.FlxGradient;
import flixel.addons.display.FlxTiledSprite;


class PlayState extends FlxState
{
	public static inline var TOOL_SMALL:Int = 0;
	public static inline var TOOL_LARGE:Int = 1;
	public static inline var TOOL_FILL:Int = 2;
	public static inline var TOOL_ERASE:Int = 3;
	public var emptyImg:BitmapData;
	private var drawMap:FlxTilemap;
	private var mapData:Array<Int>;
	private var palette:FlxTilemap;
	private var selectedPalette:Int = -1;
	private var selectedTool:Int = TOOL_SMALL;
	private var selector:FlxSprite;
	private var smallButton:ToolButton;
	private var largeButton:ToolButton;
	private var fillButton:ToolButton;
	private var eraseButton:ToolButton;
	private var doneButton:ToolButton;
	private var abortButton:ToolButton;
	public var TileID:Int = -1;
	public var TileX:Int = -1;
	public var TileY:Int = -1;
	public var neighbors:Array<FlxSprite>;
	public var neighBack:FlxSprite;
	public var bigNeighbors:Array<FlxSprite>;
	public var tileLocation:FlxText;

	override public function create():Void
	{
		Connection.state = this;
		bgColor = 0xff909090;

		initEmptyImg();

		initEditMap();
		
		initNeighbors();


		smallButton = new ToolButton(Std.int(drawMap.x + drawMap.width + 72), 342, AssetPaths.toolPencil_sm__png, clickSmall);
		add(smallButton);
		largeButton = new ToolButton(Std.int(drawMap.x + drawMap.width + 134), 342, AssetPaths.toolPencil__png, clickLarge);
		add(largeButton);
		fillButton = new ToolButton(Std.int(drawMap.x + drawMap.width + 196), 342, AssetPaths.toolFill__png, clickFill);
		add(fillButton);
		eraseButton = new ToolButton(Std.int(drawMap.x + drawMap.width + 258), 342, AssetPaths.toolEraser__png, clickErase);
		add(eraseButton);

		palette = new FlxTilemap();
		palette.loadMapFromArray([1,2,3,4,5,6,7,8,9],3,3,AssetPaths.big_tiles__png,80,80);
		palette.x = drawMap.x + drawMap.width + 72;
		palette.y = 434;
		
		var pFrame:FlxSprite = new FlxSprite(palette.x -2 ,palette.y -2);
		pFrame.makeGraphic(Std.int(palette.width + 4), Std.int(palette.height + 4), 0xff909090);
		pFrame.drawRect(2, 2, palette.width,palette.height, 0xff303030);

		add(pFrame);		
		add(palette);

		var pGrid:FlxTileblock = new FlxTileblock(Std.int(palette.x),Std.int(palette.y),Std.int(palette.width),Std.int(palette.height));
		pGrid.loadTiles(AssetPaths.big_grid__png,80,80,0);
		add(pGrid);

		selector = new FlxSprite();
		selector.loadGraphic(AssetPaths.selectedTile__png);
		add(selector);

		selectPalette(1);

		smallButton.locked = true;

		abortButton = new ToolButton(Std.int(drawMap.x + drawMap.width + 72), Std.int(drawMap.y + drawMap.height), AssetPaths.trashcanOpen__png, clickAbort, ToolButton.BTN_RED);
		add(abortButton);

		doneButton = new ToolButton(Std.int(drawMap.x + drawMap.width + 258), Std.int(drawMap.y + drawMap.height), AssetPaths.save__png, clickDone, ToolButton.BTN_GREEN);
		add(doneButton);

		var key:FlxSprite = new FlxSprite();
		key.loadGraphic(AssetPaths.map_key__png);
		key.x = drawMap.x - 8;
		key.y = drawMap.y + drawMap.height + 20;
		add(key);
		
		tileLocation = new FlxText(Std.int(pFrame.x), Std.int(drawMap.y - 50), pFrame.width, "0, 0", 22, false);
		tileLocation.color = 0x343a40;
        tileLocation.systemFont = "Segoe UI";
		tileLocation.bold = true;
		tileLocation.alignment = FlxTextAlign.CENTER;
		add(tileLocation);

		super.create();
	}

	private function initEmptyImg():Void
	{
		emptyImg = new BitmapData(64,64,false, 0x303030);
	}

	private function initEditMap():Void
	{
		mapData =[];
		for (i in 0...Std.int(64*64))
		{
			mapData.push(0);
		}

		drawMap = new FlxTilemap();
		drawMap.loadMapFromArray(mapData, 64, 64, AssetPaths.tiles__png, 10,10);
		drawMap.x = 72;
		drawMap.y = 72;

		var frame:FlxSprite = new FlxSprite(drawMap.x ,drawMap.y);
		frame.makeGraphic(640, 640, 0xff303030);
		add(frame);

		add(drawMap);
		
		var grid:FlxTileblock = new FlxTileblock(Std.int(drawMap.x), Std.int(drawMap.y), 640, 640);
		grid.loadTiles(AssetPaths.grid__png,10,10,0);
		add(grid);
	}

	private function initNeighbors():Void
	{
		neighbors = [];
		neighBack = new FlxSprite(Std.int(drawMap.x + drawMap.width + 90), 98);
		neighBack.makeGraphic(198, 198, 0xff909090);
		

		var s:FlxSprite = new FlxSprite(Std.int(drawMap.x + drawMap.width + 92), 100);
		s.makeGraphic(64,64,0xff303030, true);
		neighbors.push(s);
		

		s = new FlxSprite(Std.int(drawMap.x + drawMap.width + 92 + 65), 100);
		s.makeGraphic(64,64,0xff303030, true);
		neighbors.push(s);
		

		s = new FlxSprite(Std.int(drawMap.x + drawMap.width + 92 + 130), 100);
		s.makeGraphic(64,64,0xff303030, true);
		neighbors.push(s);
		
		
		s = new FlxSprite(Std.int(drawMap.x + drawMap.width + 92), 165);
		s.makeGraphic(64,64,0xff303030, true);
		neighbors.push(s);
		

		s = new FlxSprite(Std.int(drawMap.x + drawMap.width + 92 + 65), 165);
		s.makeGraphic(64,64,0xff303030, true);
		neighbors.push(s);
		

		s = new FlxSprite(Std.int(drawMap.x + drawMap.width + 92 + 130), 165);
		s.makeGraphic(64,64,0xff303030, true);
		neighbors.push(s);
		

		s = new FlxSprite(Std.int(drawMap.x + drawMap.width + 92 ), 230);
		s.makeGraphic(64,64,0xff303030, true);
		neighbors.push(s);
		

		s = new FlxSprite(Std.int(drawMap.x + drawMap.width + 92 + 65), 230);
		s.makeGraphic(64,64,0xff303030, true);
		neighbors.push(s);
		

		s = new FlxSprite(Std.int(drawMap.x + drawMap.width + 92 + 130), 230);
		s.makeGraphic(64,64,0xff303030, true);
		neighbors.push(s);
		

		bigNeighbors = [];

		var grids:Array<FlxTiledSprite> = [];
		var grid:FlxTiledSprite;

		var b:FlxSprite;
		for(i in 0...8)
		{
			b = new FlxSprite();
			b.makeGraphic(64,64, 0xff303030, true, "b"+Std.string(i));
			b.scale.set(10,10);
			b.updateHitbox();
			bigNeighbors.push(b);

			grid = new FlxTiledSprite(AssetPaths.grid__png,640,640);
			grids.push(grid);

		}

		bigNeighbors[0].x = (drawMap.x - 642);
		bigNeighbors[0].y = (drawMap.y - 642);
		grids[0].x = bigNeighbors[0].x;
		grids[0].y = bigNeighbors[0].y;

		bigNeighbors[1].x = drawMap.x;
		bigNeighbors[1].y = (drawMap.y - 642);
		grids[1].x = bigNeighbors[1].x;
		grids[1].y = bigNeighbors[1].y;

		bigNeighbors[2].x = (drawMap.x + 642);
		bigNeighbors[2].y = (drawMap.y - 642);
		grids[2].x = bigNeighbors[2].x;
		grids[2].y = bigNeighbors[2].y;

		bigNeighbors[3].x = (drawMap.x - 642);
		bigNeighbors[3].y = drawMap.y;
		grids[3].x = bigNeighbors[3].x;
		grids[3].y = bigNeighbors[3].y;

		bigNeighbors[4].x = (drawMap.x + 642);
		bigNeighbors[4].y = drawMap.y;
		grids[4].x = bigNeighbors[4].x;
		grids[4].y = bigNeighbors[4].y;

		bigNeighbors[5].x = (drawMap.x - 642);
		bigNeighbors[5].y = (drawMap.y + 642);
		grids[5].x = bigNeighbors[5].x;
		grids[5].y = bigNeighbors[5].y;

		bigNeighbors[6].x = drawMap.x;
		bigNeighbors[6].y = (drawMap.y + 642);
		grids[6].x = bigNeighbors[6].x;
		grids[6].y = bigNeighbors[6].y;

		bigNeighbors[7].x = (drawMap.x + 642);
		bigNeighbors[7].y = (drawMap.y + 642);
		grids[7].x = bigNeighbors[7].x;
		grids[7].y = bigNeighbors[7].y;

		add(bigNeighbors[0]);
		add(bigNeighbors[1]);
		add(bigNeighbors[2]);
		add(bigNeighbors[3]);
		add(bigNeighbors[4]);
		add(bigNeighbors[5]);
		add(bigNeighbors[6]);
		add(bigNeighbors[7]);

		add(grids[0]);
		add(grids[1]);
		add(grids[2]);
		add(grids[3]);
		add(grids[4]);
		add(grids[5]);
		add(grids[6]);
		add(grids[7]);

		buildWhiteFrame();

		add(neighBack);
		add(neighbors[0]);
		add(neighbors[1]);
		add(neighbors[2]);
		add(neighbors[3]);
		add(neighbors[4]);
		add(neighbors[5]);
		add(neighbors[6]);
		add(neighbors[7]);
		add(neighbors[8]);

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


	public function selectPalette(PaletteNo:Int):Void
	{
		selectedPalette = PaletteNo;
		selector.x = (palette.x-3)+(((PaletteNo-1) % 3)*80);
		selector.y = (palette.y-3)+(Std.int((PaletteNo-1) / 3) * 80);
	}

	private function clickSmall():Void
	{
		largeButton.locked = fillButton.locked = eraseButton.locked = false;
		smallButton.locked = true;
		selectedTool = TOOL_SMALL;
	}
	private function clickLarge():Void
	{
		smallButton.locked = fillButton.locked = eraseButton.locked = false;
		largeButton.locked = true;		
		selectedTool = TOOL_LARGE;
	}
	private function clickFill():Void
	{
		largeButton.locked = smallButton.locked = eraseButton.locked = false;
		fillButton.locked = true;
		selectedTool = TOOL_FILL;
	}
	private function clickErase():Void
	{
		largeButton.locked = fillButton.locked = smallButton.locked = false;
		eraseButton.locked = true;
		selectedTool = TOOL_ERASE;
	}

	public function init(TID:Int, X:Int, Y:Int):Void
	{
		TileID = TID;
		TileX = X;
		TileY = Y;
		tileLocation.text = Std.string(TileX) + ", " + Std.string(TileY);
		Connection.getNeighbors(TileID);
		for (x in 0...drawMap.widthInTiles)
		{
			for (y in 0...drawMap.heightInTiles)
			{
				drawMap.setTile(x, y, 0);
			}
		}
		clickSmall();
		selectPalette(1);
		
	}

	private function clickAbort():Void
	{
		var Abort:DialogSubstate = new DialogSubstate("Are you sure you want to abort editing this tile?\n\nYou will lose any changes you made to the tile, and it will be released for someone else to edit, instead.",DialogSubstate.BTN_YESNO,function(Resp:Int){
					if (Resp == DialogSubstate.RESP_YES)
					{
						// exit?

						// clear the map
						

						var base:Dynamic = window;
						base.abortAddTile();
					}
				});
		
		openSubState(Abort);
	}
	private function clickDone():Void
	{
		var Save:DialogSubstate = new DialogSubstate("Save this Tile?", DialogSubstate.BTN_YESNO,function(Resp:Int){
			
			if (Resp == DialogSubstate.RESP_YES)
			{
				if (saveTile())
				{
					 var base:Dynamic = window;
					 base.closeEditor(TileX, TileY);
				}
			} 
			else 
			{
				// nothing?
			}

		});
		openSubState(Save);
		
	}

	private function saveTile():Bool
	{
		var errors:Array<String> = [];
		var tileData:Array<Int>;

		if (drawMap.getTileInstances(0) != null)
			errors.push("You cannot leave any part of your tile blank.");

		if (errors.length > 0)
		{
			var err:DialogSubstate = new DialogSubstate("There were errors saving your tile:\n\n"+errors.join("\n")+"\n\nPlease correct and save again.", DialogSubstate.BTN_OKAY);
			openSubState(err);
			return false;
		}	
		
		tileData = drawMap.getData();

		Connection.saveTile(TileID, tileData);

		return true;

	}

	override public function update(elapsed:Float):Void
	{
		var overPalette:Bool = FlxG.mouse.x >= palette.x && FlxG.mouse.x <= palette.x + palette.width && FlxG.mouse.y >= palette.y && FlxG.mouse.y <= palette.y + palette.height;
		var overMap:Bool = FlxG.mouse.x + (selectedTool == TOOL_LARGE ? 20 : 10) >= drawMap.x && FlxG.mouse.x <= drawMap.x + drawMap.width && FlxG.mouse.y + (selectedTool == TOOL_LARGE ? 20 : 10) >= drawMap.y && FlxG.mouse.y <= drawMap.y + drawMap.height;

		if(overMap && FlxG.mouse.useSystemCursor)
		{
			FlxG.mouse.useSystemCursor = false;
			if (selectedTool == TOOL_LARGE)
				FlxG.mouse.load(AssetPaths.pointer_2__png);
			else
				FlxG.mouse.load(AssetPaths.pointer_1__png);
		}
		else if (!overMap && !FlxG.mouse.useSystemCursor)
		{
			FlxG.mouse.useSystemCursor = true;
		}
		 
		if (overPalette)
		{
			if (FlxG.mouse.justPressed)
			{
				var s:Int = palette.getTile(Std.int((FlxG.mouse.x - palette.x) / 80), Std.int((FlxG.mouse.y - palette.y) / 80));
				s = Std.int(FlxMath.bound(s, 0, 9));
				selectPalette(s);
			}
		}
		else if (overMap)
		{
			
			var tX:Int = Math.round((FlxG.mouse.x - drawMap.x) / 10);
			var tY:Int = Math.round((FlxG.mouse.y - drawMap.y) / 10);
			switch(selectedTool)
			{
				case TOOL_SMALL:
					if (FlxG.mouse.pressed)
						paintTile(tX, tY, selectedPalette);

				case TOOL_LARGE:
					if (FlxG.mouse.pressed)
					{
						paintTile(tX, tY, selectedPalette);
						paintTile(tX+1, tY, selectedPalette);
						paintTile(tX+1, tY+1, selectedPalette);
						paintTile(tX, tY+1, selectedPalette);
					}

				case TOOL_ERASE:
					if (FlxG.mouse.pressed)
						paintTile(tX, tY, 0);

				case TOOL_FILL:
					if(FlxG.mouse.justPressed)
					{
						var fillOver:Int = drawMap.getTile(tX, tY);
						floodFill(tX, tY, fillOver, selectedPalette);
					}
			}
			
		}

		super.update(elapsed);
		
	}

	public function paintTile(X:Int, Y:Int, Palette:Int):Bool
	{
		if (X >= 0 && X < drawMap.widthInTiles && Y >= 0 && Y < drawMap.heightInTiles)
		{
			drawMap.setTile(X, Y, Palette, true);
			neighbors[4].pixels.setPixel(X, Y, getPaletteColor(Palette));
			neighbors[4].dirty = true;
			return true;
		}
		return false;
	}

	public function getPaletteColor(PIndex:Int):FlxColor
	{
		return switch(PIndex)
			{
				case 1:
					0x66cc00;
				case 2:
					0x006600;
				case 3:
					0x999966;
				case 4:
					0xfbf236;
				case 5:
					0x6dc2ca;
				case 6:
					0x3333ff;
				case 7:
					0x8a6f30;
				case 8:
					0x990000;
				case 9:
					0xffffff;
				default:
					0x303030;
			};
	}

	public function floodFill(X:Int, Y:Int, OldTile:Int, NewTile:Int):Void
	{

		if (OldTile == NewTile) return;

		var dx:Array<Int> = [0, 1, 0, -1];
		var dy:Array<Int> = [-1, 0, 1, 0];
		var stack:Array<IntPoint> = [];
		var tmpPoint:IntPoint;
		stack.push({x:X, y:Y});
		while(stack.length > 0)
		{
			tmpPoint = stack.pop();
			paintTile(tmpPoint.x, tmpPoint.y, NewTile);
			for (i in 0...4)
			{
				var nx:Int = tmpPoint.x + dx[i];
				var ny:Int = tmpPoint.y + dy[i];
				if (nx >= 0 && nx < drawMap.widthInTiles && ny >= 0 && ny < drawMap.heightInTiles)
				{
					if (drawMap.getTile(nx, ny) == OldTile)
						stack.push({x:nx, y:ny});
				}
			}
		}
	}

}

typedef IntPoint = {
	var x:Int;
	var y:Int;
};

@:expose
class EditorFunctions 
{
    function new() {
        // nothing...
    }
    public function init(TileID:Int, X:Int, Y:Int):Void
    {
        cast(FlxG.state, PlayState).init(TileID, X, Y);
    }
}