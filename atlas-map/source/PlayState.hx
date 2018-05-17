package;

import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxState;
import js.Browser.window;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class PlayState extends FlxState
{
	public var group:TileGroup;
	private var invisMouse:FlxSprite;
	private var startDrag:Bool = false;
	private var dragStartPos:FlxPoint;
	private var clickTime:Float = 0;
	private var scale:FlxSprite;

	override public function create():Void
	{

		group = new TileGroup();

		invisMouse = new FlxSprite();
		invisMouse.makeGraphic(1,1,FlxColor.RED);

		dragStartPos = FlxPoint.get();

		add(group);
		//add(invisMouse);

		Connection.getMapData(gotMapData);

		new FlxTimer().start(1, updateMap, 0);

		scale = new FlxSprite();
		scale.loadGraphic(AssetPaths.scale__png);
		
		scale.scrollFactor.set();
		add(scale);
		
		super.create();
	}

	private function updateMap(_):Void
	{
		Connection.getMapData(gotMapData);
	}

	override public function update(elapsed:Float):Void
	{
		Input.update(elapsed);
		
		if (!startDrag)
		{
			if (FlxG.mouse.justReleased)
			{	
				clickTime = 0;
				invisMouse.setPosition(FlxG.mouse.x, FlxG.mouse.y);
				invisMouse.update(elapsed);

				FlxG.overlap(invisMouse, group, clicked);
			}
			else if (FlxG.mouse.pressed)
			{
				clickTime+=elapsed;
				if (clickTime >= .1)
				{
					startDrag = true;
					dragStartPos.set(FlxG.mouse.x, FlxG.mouse.y);
				}
			}
		}
		else if (FlxG.mouse.pressed)
		{
			var dX:Float = FlxG.mouse.x - dragStartPos.x;
			var dY:Float = FlxG.mouse.y - dragStartPos.y;
			group.x += FlxMath.bound(dX,-300,300);
			group.y += FlxMath.bound(dY,-300,300);
			dragStartPos.set(FlxG.mouse.x, FlxG.mouse.y);

		}
		else if (!FlxG.mouse.pressed)
		{
			startDrag = false;
			clickTime = 0;
		}

		scale.x = 40;
		scale.y = FlxG.height - 40 - scale.height;

		super.update(elapsed);
		
	}

	private function clicked(M:FlxSprite, T:MapTile):Void
	{
		if (T.id > -1)
		{
			
			var base:Dynamic = window;
			base.displayTile(T.id);
		}
	}

	private function gotMapData(Data:Array<Array<Int>>, MinMax:Dynamic):Void
	{
		group.updateData(Data, MinMax);
	}

}

