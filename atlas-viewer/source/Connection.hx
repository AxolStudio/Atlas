package;


import openfl.geom.Point;
import flixel.FlxSprite;
import openfl.display.BitmapData;
import haxe.Http;
import haxe.Json;


class Connection
{

    public static var state:PlayState;
    public static inline var BASE_URL:String = "https://atlas.axolstudio.com/scripts/";

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

        for (x in data.startX...data.endX+1)
        {
            
            i = x - data.startX;
            for(y in data.startY...data.endY+1)
            {
                j = y - data.startY;
                if (mapData[x][y] > -1)
                {
                    r = [state.bigNeighbors[j * 3 + i]];

                    loadTile(mapData[x][y], r);
                }
                else
                {
                    state.bigNeighbors[j * 3 + i].pixels.copyPixels(state.emptyImg, state.emptyImg.rect, new Point());
                    state.bigNeighbors[j * 3 + i].dirty = true;
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

typedef TileID = {
    ?tid:Int
}
