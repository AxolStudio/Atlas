package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxSpriteUtil;

class MapKey extends FlxSpriteGroup
{

    public static inline var ORIENT_TOP:Int = 0;
    public static inline var ORIENT_LEFT:Int = 1;
    public static inline var ORIENT_BOTTOM:Int = 2;
    public static inline var ORIENT_RIGHT:Int = 3;

    public var id:Int;
    public var orientation:Int;
    public var parent:TileGroup;

    public function new(?ID:Int = -1, X:Int, Y:Int, Orientation:Int, Parent:TileGroup)
    {
        super(X, Y);
        id = ID;
        orientation = Orientation;
        parent = Parent;
        
        var w:Int=0;
        var h:Int=0;
        if (orientation == ORIENT_TOP || orientation == ORIENT_BOTTOM)
        {
            w = 64;
            h = 30;
        }
        else 
        {
            w = 30;
            h = 64;
        }

        var back:FlxSprite = new FlxSprite();
        back.makeGraphic(w, h, FlxMath.isOdd(id) ? 0xffffffff : 0xff999999, false, "key-" + Std.string(orientation) + (FlxMath.isOdd(id)?"o":"e"));
        back.x = 0;
        back.y = 0;
        switch(orientation)
        {
            case ORIENT_TOP:
                FlxSpriteUtil.drawRect(back, 0, 27, 64, 29, 0xff000000);
            case ORIENT_BOTTOM:
                FlxSpriteUtil.drawRect(back, 0, 0, 64, 3, 0xff000000);
            case ORIENT_LEFT:
                FlxSpriteUtil.drawRect(back, 27, 0, 29, 64, 0xff000000);
            case ORIENT_RIGHT:
                FlxSpriteUtil.drawRect(back, 0, 0, 3, 64, 0xff000000);
        }
        add(back);

        var digit:FlxText = new FlxText();
        digit.text = Std.string(id);
        digit.systemFont = "Segoe UI";
        digit.size = 10;
        digit.bold = true;
        digit.color = 0xff000000;
        digit.borderSize =1;
        digit.borderStyle = FlxTextBorderStyle.OUTLINE;
        digit.borderColor = 0xffffffff;
        digit.borderQuality=1;        
        digit.x = (w/2) - (digit.width/2);
        digit.y = (h/2) - (digit.height/2);
        add(digit);
        
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        switch(orientation)
        {
            case ORIENT_TOP:
                y = 0;
            case ORIENT_BOTTOM:
                y = FlxG.height - 30;
            case ORIENT_LEFT:
                x = 0;
            case ORIENT_RIGHT:
                x = FlxG.width - 30;

        }
    }

}