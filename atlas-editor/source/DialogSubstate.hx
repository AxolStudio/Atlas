package;

import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.text.FlxText;
using flixel.util.FlxSpriteUtil;

class DialogSubstate extends FlxSubState
{
    public static inline var BTN_OKAY:Int = 0;
    public static inline var BTN_YESNO:Int = 1;

    public static inline var RESP_OKAY:Int =0;
    public static inline var RESP_YES:Int =1;
    public static inline var RESP_NO:Int =2;

    private var fade:FlxSprite;
    private var back:FlxSprite;
    private var message:FlxText;
    private var callback:Int->Void;
    private var buttons:Array<TextButton>;
    public var ready:Bool = false;
    private var btnClicked:Int = -1;


    public function new(?Msg:String= "", ?Btns:Int = 0, ?Callback:Int->Void = null)
    {
        super(0);
    
        closeCallback = closed;
        callback = Callback;

        fade = new FlxSprite(0,0);
        fade.makeGraphic(FlxG.width, FlxG.height, 0x33000000);
        fade.alpha =0;
        
        message = new FlxText(0,0,Std.int(Math.min(Math.ceil(FlxG.width * .6), 500)) - 20,Msg, 16, false);
        message.color = 0x343a40;
        message.systemFont = "Segoe UI";
        message.height += 20;
        message.alpha =0;
        
        back = new FlxSprite(0,0);
        back.makeGraphic(Std.int(Math.min(Math.ceil(FlxG.width * .6), 500)), Math.ceil(message.height + 80), 0);
        back.drawRoundRect(0,0,back.width, back.height, 20,20,FlxColor.WHITE);
        back.alpha =0;
        back.screenCenter();

        message.x = back.x + 10;
        message.y = back.y + 10;
        
        add(fade);
        add(back);
        add(message);

        buttons = [];
        var b:TextButton;
        switch (Btns)
        {
            case BTN_OKAY:
                b = new TextButton(Std.int(FlxG.width/2) - 75, Std.int(message.y + message.height + 10), "Okay", clickOkay,TextButton.BTN_BLUE);
                b.alpha =0;
                buttons.push(b);
                add(b);
            case BTN_YESNO:
                b = new TextButton(Std.int(back.x + 10), Std.int(message.y + message.height + 10), "No", clickNo,TextButton.BTN_RED);
                b.alpha =0;
                buttons.push(b);
                add(b);
                b = new TextButton(Std.int(back.x + back.width - 160), Std.int(message.y + message.height + 10), "Yes", clickYes,TextButton.BTN_GREEN);
                b.alpha =0;
                buttons.push(b);
                add(b);
        }

        FlxTween.tween(fade, {alpha:1},.025,{onComplete:function(_){
            FlxTween.num(0,1,.025,{onComplete:function(_){
                ready = true;
            }}, function(Value:Float){
                message.alpha = back.alpha = Value;
                for (b in buttons)
                    b.alpha = Value;
            });
        }});

    }

    private function clickOkay():Void
    {
        if (!ready) return;
        ready = false;
        btnClicked = RESP_OKAY;
        fadeOut();
    }

    private function clickYes():Void
    {
        if (!ready) return;
        ready = false;
        btnClicked = RESP_YES;
        fadeOut();
    }
    
    private function clickNo():Void
    {
        if (!ready) return;
        ready = false;
        btnClicked = RESP_NO;
        fadeOut();
    }

    private function fadeOut():Void
    {

        FlxTween.num(1,0,.025,{onComplete:function(_){
                FlxTween.tween(fade, {alpha:0},.025,{onComplete:function(_){
                    close();
                }});
            }}, function(Value:Float){
                message.alpha = back.alpha = Value;
                for (b in buttons)
                    b.alpha = Value;
            });

    }

    private function closed():Void
    {
        if (callback != null)
            callback(btnClicked);
    }
}