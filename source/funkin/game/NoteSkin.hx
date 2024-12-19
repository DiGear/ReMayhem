package funkin.game;

import flixel.graphics.frames.FlxFramesCollection;
import haxe.xml.Access;

final class NoteSkin {
	public var skin:String = "game/notes/default";
	public var splashSkin:String = "default";

	public var antialiased:Bool = true;

	public function new() {}

	public inline function loadFromXML(xml:Access) {
		if (xml.x.exists("noteSkin"))
			skin = "game/notes/" + xml.x.get("noteSkin");
		if (xml.x.exists("noteSplashSkin"))
			splashSkin = xml.x.get("noteSplashSkin");
		if (xml.x.exists("noteAntialiased"))
			antialiased = (xml.x.get("noteAntialiased") == "true");
	}
}