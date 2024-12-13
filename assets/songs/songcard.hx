// comment to avoid vscode syntax error
var bruh:HudCamera;
var charicon:HealthIcon;
var songinfo:FlxText;
var cardmain:FlxSprite;
var cardaccent:FlxSprite;
var accentheight:Float;

function postCreate()
{
	// set up camera
	bruh = new HudCamera();
	bruh.bgColor = '#00000000';
	FlxG.cameras.add(bruh, false);

	// determine who tf made the song
	var composers:String = null; // i forgot to put this up top but i dont fucking care

	if (PlayState.difficulty == "Mayhem") {
		composers = (Reflect.hasField(SONG.meta.customValues, "mcomposers") ? SONG.meta.customValues.mcomposers : "null");
	} else {
		composers = (Reflect.hasField(SONG.meta.customValues, "composers") ? SONG.meta.customValues.composers : "null");
	}

	// set up the song info
	songinfo = new FlxText(-500, 290, 0, SONG.meta.displayName + "\nby " + composers);
	songinfo.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, "left");
	songinfo.camera = bruh;

	// set up the info card
	cardmain = new FlxSprite(-500, 285).makeGraphic(songinfo.width + 40, 60, 0xFF222222); // 40 is a lot but its necessary padding
	cardmain.camera = bruh;

	// set up the accent color
	cardaccent = new FlxSprite(-500, 285).makeGraphic(25, 60, dad.iconColor);
	cardaccent.camera = bruh;

	// zorder
	add(cardmain);
	add(cardaccent);
	add(songinfo);
}


function onSongStart()
{
	// tween in
	FlxTween.tween(songinfo, {x: 31}, 0.8, {ease: FlxEase.sineOut});
	FlxTween.tween(cardmain, {x: 0}, 0.8, {ease: FlxEase.sineOut});
	FlxTween.tween(cardaccent, {x: 0}, 0.8, {ease: FlxEase.sineOut});

	// tween out
	FlxTween.tween(songinfo, {x: -500}, 0.8, {ease: FlxEase.sineIn, startDelay: 3.8});
	FlxTween.tween(cardmain, {x: -500}, 0.8, {ease: FlxEase.sineIn, startDelay: 3.8});
	FlxTween.tween(cardaccent, {x: -500}, 0.8, {ease: FlxEase.sineIn, startDelay: 3.8});
}
