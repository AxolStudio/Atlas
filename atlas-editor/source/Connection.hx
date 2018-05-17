package;


import openfl.geom.Point;
import flixel.FlxSprite;
import openfl.display.BitmapData;
import haxe.Http;
import haxe.Json;


class Connection
{

    public static var state:PlayState;
    public static inline var BASE_URL:String = "http://atlas.axolstudio.com/scripts/";
    public static inline var TILE_URL:String = "http://atlas.axolstudio.com/tiles/";


    static public function saveTile(TileID:Int, B:Array<Int>):Void
    {
        var h:Http= new Http(BASE_URL + "saveTile.php");
        h.onError = onError;
		h.onStatus = onStatus;
		h.onData = onSaveTile;
        var data:TileData = {
            tid:TileID,
            tdata:B
        };
        h.setPostData(Json.stringify(data));
        h.request(true);
    }

    static public function getNeighbors(TileID:Int):Void
    {
        var h:Http = new Http(BASE_URL + "getTileNeighbors.php");
        h.onError = onError;
        h.onStatus = onStatus;
        h.onData = onGetNeighbors;
        var data:TileID = {
            tid:TileID
        };
        h.setPostData(Json.stringify(data));
        h.request(true);
    }

    public static function onGetNeighbors(msg:String):Void
    {
        var data = Json.parse(msg);
        var mapData:Array<Array<Int>> = data.mapData;
        var i:Int = 0;
        var j:Int = 0;
        var r:Array<FlxSprite>= [];
        var nNo:Int;

        for (x in data.startX...data.endX+1)
        {
            
            i = x - data.startX;
            for(y in data.startY...data.endY+1)
            {
                j = y - data.startY;
                nNo = j * 3 + i;
                if (mapData[x][y] > -1 && nNo != 4)
                {
                    r = [state.neighbors[nNo]];
                    if (nNo < 4)
                    {
                        r.push(state.bigNeighbors[nNo]);
                    }
                    else if (nNo > 4)
                    {
                        r.push(state.bigNeighbors[nNo-1]);
                    }

                    loadTile(mapData[x][y], r);
                }
                else
                {
                    state.neighbors[nNo].pixels.copyPixels(state.emptyImg, state.emptyImg.rect, new Point());
                    state.neighbors[nNo].dirty = true;
                    if (nNo!=4)
                    {
                        if (nNo > 4)
                            nNo--;
                        state.bigNeighbors[nNo].pixels.copyPixels(state.emptyImg, state.emptyImg.rect, new Point());
                        state.bigNeighbors[nNo].dirty = true;
                    }
                }
            }
        }
    }



   

    static public function loadTile(TileId:Int, Receivers:Array<FlxSprite>):Void
    {
        var h:Http = new Http(BASE_URL + "getTileImage.php");

        h.onError = onError;
		h.onStatus = onStatus;
		h.onData = onLoadTile.bind(_, Receivers);

        var data:TileID = {
            tid: TileId
        };

        h.setPostData(Json.stringify(data));

        h.request(true);
        

    }

    public static function onLoadTile(msg:String, Receivers:Array<FlxSprite>):Void
    {
        var data = Json.parse(msg);
        BitmapData.fromBase64(StringTools.trim(data.tiledata),"image/png", function(b) {
            for (r in Receivers)
            {
                r.pixels.copyPixels(b,b.rect,new Point());
                r.dirty = true;
            }
        });
        
    }

    private static function onSaveTile(msg:String):Void
    {
        var data = Json.parse(msg);
        if (data.errors.length > 0)
        {
            state.openSubState(new DialogSubstate("There was a problem saving your tile.\n\n" + data.errors.join("\n") + "\nPlease try again, or abort and start a new Tile.",DialogSubstate.BTN_OKAY));
        }
        #if debug
        trace("onSaveTile: " + msg);
        #end
    }

    public static function onError(msg:String):Void
	{
		#if debug
		trace("Error: " + msg);
        #end
		
	}
	
	public static function onStatus(msg:Int):Void
	{
		#if debug
		trace("Status: " + msg);
		#end
	}

}

typedef TileData = {
    ?tid:Int,
    ?tdata:Array<Int>
}

typedef TileID = {
    ?tid:Int
}
