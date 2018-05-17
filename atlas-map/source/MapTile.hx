package;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxSprite;

class MapTile extends FlxSprite
{
    public var id:Int;

    public function new(?ID:Int = -1, X:Int, Y:Int)
    {
        super(X, Y);
        id = ID;
        makeGraphic(64,64,0xff303030, false, "empty");
        
    }

    public function setGraphic(Graphic:FlxGraphicAsset):Void
    {
        loadGraphic(Graphic, false, 64, 64, true, Graphic);
    }

    public function clearGraphic():Void
    {
        makeGraphic(64,64,0xff303030, false, "empty");
    }
}