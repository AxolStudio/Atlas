package;

import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.ui.FlxSpriteButton;
class ToolButton extends FlxSpriteButton
{
    public static inline var BTN_BLUE:Int =0;
    public static inline var BTN_RED:Int =1;
    public static inline var BTN_GREEN:Int =2;
    public var locked(default, set):Bool = false;
    public function new(X:Int, Y:Int, Image:FlxGraphicAsset, OnClick:Void->Void, ?Color:Int = BTN_BLUE)
    {
        var spr:FlxSprite = new FlxSprite();
        spr.loadGraphic(Image);
        super(X, Y, spr, OnClick);
        
        loadGraphic(switch (Color)
                {
                    case BTN_RED:
                        AssetPaths.red_button__png;
                    case BTN_GREEN:
                        AssetPaths.green_button__png;
                    case BTN_BLUE:
                        AssetPaths.full_button__png;
                    default:
                        AssetPaths.full_button__png;
                }, true, 50, 50);
		labelOffsets[0].x = 0;
		labelOffsets[0].y = 0;
		labelOffsets[1].x = 0;
		labelOffsets[1].y = 0;
		labelOffsets[2].x = 0;
		labelOffsets[2].y = 0;
        labelAlphas[0] = 1;
        labelAlphas[2] = .8;
        labelAlphas[3] = .9;
    }
    override private function updateButton():Void
    {
        if(locked)
            status = FlxButton.PRESSED;
        else
            super.updateButton();
    }

    private function set_locked(Value:Bool):Bool
    {
        if(locked && !Value)
        {
            onOutHandler();
        }
        else if (Value)
        {
            status = FlxButton.PRESSED;
        }
        locked = Value;
        return locked;
    }

}