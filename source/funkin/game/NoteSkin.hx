package funkin.game;

import flixel.graphics.frames.FlxFramesCollection;
import haxe.xml.Access;

final class NoteSkin {
	public var isFrames:Bool = true;
	public var antialiased:Bool = true;

	public var skin:Dynamic = Paths.getFrames("game/notes/default");
	public var splashSkin:String = "default";

	public var scale:Float = 1.0;
	public var width:Int = 17;
	public var height:Int = 17;

	public function new() {}

	public inline function loadFromXML(xml:Access) {
		if (xml.x.exists("noteScale"))
			scale = Std.parseFloat(xml.x.get("noteScale"));
		if (xml.x.exists("noteAntialiased"))
			antialiased = (xml.x.get("noteAntialiased") == "true");
		if (xml.x.exists("noteSkinIsFrames"))
			isFrames = (xml.x.get("noteSkinIsFrames") == "true");

		if (xml.x.exists("noteWidth") && xml.x.exists("noteHeight")) {
			width = Std.parseInt(xml.x.get("noteWidth"));
			height = Std.parseInt(xml.x.get("noteHeight"));
		}

		if (xml.x.exists("noteSkin")) {
			if (isFrames) {
				skin = Paths.getFrames("game/notes/" + xml.x.get("noteSkin"));
			} else {
				skin = Paths.image("game/notes/" + xml.x.get("noteSkin"));
			}
		}
		if (xml.x.exists("noteSplashSkin"))
			splashSkin = xml.x.get("noteSplashSkin");
	}
}