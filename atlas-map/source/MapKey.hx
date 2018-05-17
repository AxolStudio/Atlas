package;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText;

class MapKey extends FlxTypedSpriteGroup<FlxText>
{

    public static inline var ORIENT_TOP:Int = 0;
    public static inline var ORIENT_LEFT:Int = 1;
    public static inline var ORIENT_BOTTOM:Int = 2;
    public static inline var ORIENT_RIGHT:Int = 3;

    public var id:Int;
    public var orientation:Int;

    public function new(?ID:Int = -1, X:Int, Y:Int, Orientation:Int)
    {
        super(X, Y);
        id = ID;
        orientation = Orientation;
        
        switch(orientation)
        {
            case ORIENT_TOP:
                width = 64;
                height = 10;
            case ORIENT_BOTTOM:
                width = 64;
                height = 10;
            case ORIENT_LEFT:
                width = 10;
                height = 64;
            case ORIENT_RIGHT:
                width = 10;
                height = 64;
        }

        
        
        



    

        
        
    }

}