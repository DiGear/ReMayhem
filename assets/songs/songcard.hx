//

var songTitle:FlxText;
var songAuthors:FlxText;
var border:FlxSprite;
var cardBack:FlxSprite;
var cardAccent:FlxSprite;

function postCreate() {
	var title = SONG.meta.displayName;
	if (PlayState.difficulty == "Mayhem") {
		title = title + "-M";
	}

	var composers:String;
	// we're checking if you're playing Mayhem, if you are, we're gonna use the mayhem remix composers
	if (PlayState.difficulty == "Mayhem") {
		composers = (Reflect.hasField(SONG.meta.customValues, "mcomposers") ? SONG.meta.customValues.mcomposers : "null");
	} else {
		composers = (Reflect.hasField(SONG.meta.customValues, "composers") ? SONG.meta.customValues.composers : "null");
	}

	songTitle = new FlxText(-500, 290, 0, title);
	songTitle.setFormat(Paths.font("vcr.ttf"), 28, FlxColor.WHITE, "left");
	songTitle.camera = camHUD;

	songAuthors = new FlxText(-500, 290 + 32, 0, composers);
	songAuthors.setFormat(Paths.font("vcr.ttf"), 12, FlxColor.WHITE, "left");
	songAuthors.camera = camHUD;

	// border, theres probably a better way to do this
	border = new FlxSprite(-500, 281).makeGraphic(songTitle.width + 45, 68, 0xFF000000);
	border.camera = camHUD;

	// set up the info card
	cardBack = new FlxSprite(-500, 285).makeGraphic(songTitle.width + 40, 60, 0xFF222222); // 40 is a lot but its necessary padding
	cardBack.camera = camHUD;

	// set up the accent color
	cardAccent = new FlxSprite(-500, 285).makeGraphic(25, 60, dad.iconColor);
	cardAccent.camera = camHUD;

	add(border);
	add(cardBack);
	add(cardAccent);
	add(songTitle);
	add(songAuthors);
}
	
function onSongStart() {
	FlxTween.tween(songTitle, {x: 31}, 0.8, {ease: FlxEase.sineOut});
	FlxTween.tween(songAuthors, {x: 31}, 0.8, {ease: FlxEase.sineOut});
	FlxTween.tween(border, {x: 0}, 0.8, {ease: FlxEase.sineOut});
	FlxTween.tween(cardBack, {x: 0}, 0.8, {ease: FlxEase.sineOut});
	FlxTween.tween(cardAccent, {x: 0}, 0.8, {ease: FlxEase.sineOut});

	FlxTween.tween(songTitle, {x: -500}, 0.8, {ease: FlxEase.sineIn, startDelay: 3.8});
	FlxTween.tween(songAuthors, {x: -500}, 0.8, {ease: FlxEase.sineIn, startDelay: 3.8});
	FlxTween.tween(border, {x: -500}, 0.8, {ease: FlxEase.sineIn, startDelay: 3.8});
	FlxTween.tween(cardBack, {x: -500}, 0.8, {ease: FlxEase.sineIn, startDelay: 3.8});
	FlxTween.tween(cardAccent, {x: -500}, 0.8, {ease: FlxEase.sineIn, startDelay: 3.8});
}
	