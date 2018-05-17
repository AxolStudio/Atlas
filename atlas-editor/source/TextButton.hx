package;

import flixel.util.FlxColor;
import flixel.ui.FlxButton;

class TextButton extends FlxButton
{
    public static inline var BTN_BLUE:Int =0;
    public static inline var BTN_RED:Int =1;
    public static inline var BTN_GREEN:Int =2;
    public var locked(default, set):Bool = false;
    public function new(X:Int, Y:Int, ?Text:String="", OnClick:Void->Void, ?Color:Int = BTN_BLUE)
    {
        
        super(X, Y, Text, OnClick);
        
        label.size = 20;
        label.systemFont = "Segoe UI";
        label.bold = true;
        label.color = FlxColor.WHITE;

        
        loadGraphic(switch (Color)
                {
                    case BTN_RED:
                        AssetPaths.red_button_wide__png;
                    case BTN_GREEN:
                        AssetPaths.green_button_wide__png;
                    case BTN_BLUE:
                        AssetPaths.full_button_wide__png;
                    default:
                        AssetPaths.full_button_wide__png;
                }, true, 150, 50);

		labelOffsets[0].x = 0;
		labelOffsets[0].y = 25 - (label.height/2);
		labelOffsets[1].x = 0;
		labelOffsets[1].y = 25 - (label.height/2);
		labelOffsets[2].x = 0;
		labelOffsets[2].y = 25 - (label.height/2);
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