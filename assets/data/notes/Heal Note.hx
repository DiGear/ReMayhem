var healTween:FlxTween;
var healSound:FlxSound = FlxG.sound.load(Paths.sound("heal"));

function onPlayerHit(e) {
    if (e.noteType == "Heal Note"){
        health += .125;
		healSound.play(true);
        boyfriend.color = FlxColor.GREEN;
        healTween = FlxTween.color(boyfriend, 1, FlxColor.GREEN, FlxColor.WHITE, {ease: FlxEase.quintOut, onComplete: function(twn:FlxTween){healTween = null;}});
    }
}

function onPlayerMiss(e) {
	if (e.noteType == "Heal Note"){
		healSound.play(true);
		e.cancel();
		deleteNote(e.note);
	}
}

function onDadHit(e) {
    if (e.noteType == "Heal Note"){
        health -= .125;
        dad.color = FlxColor.GREEN;
        healTween = FlxTween.color(dad, 1, FlxColor.GREEN, FlxColor.WHITE, {ease: FlxEase.quintOut, onComplete: function(twn:FlxTween){healTween = null;}});
    }
}

function onNoteCreation(e) {
    if (e.noteType == "Heal Note"){
		if (Assets.exists(Paths.image(e.noteSkinData.skin + "-heal"))) {
			e.noteFrames = e.noteSkinData.skin + "-heal";
		} else {
			e.noteFrames = "game/notes/default-heal";
		}
		e.note.updateHitbox();
	}
}

function postCreate()
    if (healTween != null)
        healTween.cancel();