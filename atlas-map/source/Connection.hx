package;

import flash.display.BitmapData;
import haxe.Http;
import haxe.Json;
import StringTools;

class Connection
{
    public static var cached_mapdata:String = "";
    public static inline var BASE_URL:String = "https://atlas.axolstudio.com/scripts/";
    public static var getMapDataCallback:Array<Array<Int>>->Dynamic->Void;
    static public function getMapData(Callback:Array<Array<Int>>->Dynamic->Void):Void
    {
        var h:Http = new Http(BASE_URL + "getMapData.php");
        
        h.onError = onError;
		h.onStatus = onStatus;
		h.onData = onGetMapData;
        getMapDataCallback = Callback;
        h.request(true);
    }

    static public function loadTile(TileId:Int, Receiver:MapTile):Void
    {
        var h:Http = new Http(BASE_URL + "getTileImage.php");

        h.onError = onError;
		h.onStatus = onStatus;
		h.onData = onLoadTile.bind(_, Receiver);

        var data:TileID = {
            tid: Std.string(TileId)
        };
        h.setPostData(Json.stringify(data));
        h.request(true);
    }

    public static function onLoadTile(msg:String, Receiver:MapTile):Void
    {
        var data = Json.parse(msg);
        BitmapData.fromBase64(StringTools.trim(data.tiledata),"image/png", function(b) {
            Receiver.setGraphic(b);
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

    public static function onGetMapData(msg:String):Void
    {
        if (cached_mapdata != msg || cached_mapdata == '')
        {
            cached_mapdata = msg;

            var mapData = Json.parse(msg);

            getMapDataCallback(mapData.mapData, mapData.minmax);
        }
        
    }


}

typedef TileID = {
    ?tid:String
}