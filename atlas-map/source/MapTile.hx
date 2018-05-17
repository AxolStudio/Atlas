package;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxSprite;
import flixel.math.FlxMath;

class MapTile extends FlxSprite
{
    public var id:Int;
    public var odd:Bool = false;

    public function new(?ID:Int = -1, X:Int, Y:Int)
    {
        super(X, Y);
        id = ID;
        odd = FlxMath.isOdd(X+Y);
        makeGraphic(64,64, odd ? 0xff202020 : 0xff303030, false, "empty-" + (odd ? 'o' : 'e'));
        
    }

    public function setGraphic(Graphic:FlxGraphicAsset):Void
    {
        loadGraphic(Graphic, false, 64, 64, true, Graphic);
    }

    public function clearGraphic():Void
    {
        makeGraphic(64,64, odd ? 0xff202020 : 0xff303030, false, "empty" + (odd ? 'o' : 'e'));
    }
}