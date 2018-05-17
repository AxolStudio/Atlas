package;

import flixel.math.FlxVelocity;
import flixel.FlxObject;
import flixel.math.FlxAngle;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;

class TileGroup extends FlxTypedSpriteGroup<MapTile>
{

    public var ScreenW:Int=0;
    public var ScreenH:Int=0;

    public var screenStartX:Int=0;
    public var screenStartY:Int=0;
    public var screenEndX:Int=0;
    public var screenEndY:Int=0;

    public var minX:Int=0;
    public var minY:Int=0;
    public var maxX:Int=0;
    public var maxY:Int=0;

    public var tiles:Map<String, MapTile>;

    public var data:Array<Array<Int>>;

    


    public function new()
    {
        super();
        
        tiles = new Map<String, MapTile>();

        x = (FlxG.width/2)-32;
        y = (FlxG.height/2)-32;

        maxVelocity.set(500,500);
        drag.set(2000,2000);

    }

    public function updateData(Data:Array<Array<Int>>, MinMax:Dynamic):Void
    {
        data = Data;

        minX = Std.int(MinMax.minx-1);
        minY = Std.int(MinMax.miny-1);
        maxX = Std.int(MinMax.maxx+1);
        maxY = Std.int(MinMax.maxy+1);

        checkScreenPos(true);
    }

    override public function update(elapsed:Float):Void
    {
        movement(elapsed);
        checkScreenPos();
        super.update(elapsed);
    }

    private function movement(elapsed:Float):Void
    {
        var L:Bool = Input.Left[Input.PRESSED];
        var R:Bool = Input.Right[Input.PRESSED];
        var U:Bool = Input.Up[Input.PRESSED];
        var D:Bool = Input.Down[Input.PRESSED];

        if(L && R)
            L = R = false;
        if (U && D)
            U = D = false;
        
        if ((L || R || U || D)) 
        {

            var f:Int = FlxObject.NONE;
            if (L)
                f |= FlxObject.LEFT;
            else if (R)
                f |= FlxObject.RIGHT;
            if (U)
                f |= FlxObject.UP;
            else if (D)
                f |= FlxObject.DOWN;

            var a:Float = FlxAngle.angleFromFacing(f);

            FlxVelocity.accelerateFromAngle(this, a, 2000, 500, false);

        }
        else
        {
            acceleration.set();
        }
    }

    public function checkScreenPos(Force:Bool = false):Void
    {
        

        var newScreenW:Int = Math.ceil(FlxG.width/65)+2;
        var newScreenH:Int = Math.ceil(FlxG.height/65)+2;
        
        var newScreenStartX:Int = Math.floor(-(x/65)-1);
        var newScreenStartY:Int = Math.floor(-(y/65)-1);
        var newScreenEndX:Int = Math.ceil(newScreenStartX + newScreenW);
        var newScreenEndY:Int = Math.ceil(newScreenStartY + newScreenH);

        if (newScreenW != ScreenW || newScreenH != ScreenH || newScreenStartX != screenStartX || newScreenStartY != screenStartY || newScreenEndX != screenEndX || newScreenEndY != screenEndY || Force)
        {
            ScreenW = newScreenW;
            ScreenH = newScreenH;
            
            screenStartX = newScreenStartX;
            screenStartY = newScreenStartY;
            screenEndX = newScreenEndX;
            screenEndY = newScreenEndY;

            fillScreen();
        }

        
    }

    public function fillScreen():Void
    {
        

        var tX:Int = screenStartX;
        var tY:Int = screenStartY;
        var t:MapTile;
        var tileID:Int = -1;
        var key:String;
        
        while (tX <= screenEndX)
        {
            tY = screenStartY;
            while (tY <= screenEndY)
            {
                key = Std.string(tX) + "," + Std.string(tY);
                
                tileID = -1;
                if (data != null)
                {
                    if (tX >= minX && tX <= maxX && tY >= minY && tY <= maxY)
                    {
                        
                        tileID = data[tX][tY];
                    }
                }
                var tAdded:Bool = false;
                if (!tiles.exists(key))
                {
                    t = new MapTile(tileID, tX, tY);
                    t.x = tX * 65;
                    t.y = tY * 65;
                    tiles.set(key, t);
                    tAdded = true;
                    add(t);
                }
                else
                {
                    t = tiles.get(key);
                }
                if (tileID != t.id || tAdded)
                {
                    t.id = tileID;
                    if (tileID == -1)
                        t.clearGraphic();
                    else
                    {

                    
                        Connection.loadTile(tileID, t);
                    }  
                }

                tY++;
            }
            tX++;
        }
    }
}