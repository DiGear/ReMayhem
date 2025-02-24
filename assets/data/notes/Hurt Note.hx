var hurtTween:FlxTween;

function onNoteHit(e)
    if (e.noteType == "Hurt Note")
        e.animSuffix = "miss";

function onPlayerHit(e) {
    if (e.noteType == "Hurt Note"){
        health -= .1;
        e.healthGain = 0;
        boyfriend.color = FlxColor.RED;
        hurtTween = FlxTween.color(boyfriend, 1, FlxColor.RED, FlxColor.WHITE, {ease: FlxEase.quintOut, onComplete: function(twn:FlxTween){hurtTween = null;}});
    }
}

function onPlayerMiss(e) {
	if (e.noteType == "Hurt Note"){
		e.cancel();
		deleteNote(e.note);
	}
}

function onDadHit(e) {
    if (e.noteType == "Hurt Note"){
        health += .1;
        dad.color = FlxColor.RED;
        hurtTween = FlxTween.color(dad, 1, FlxColor.RED, FlxColor.WHITE, {ease: FlxEase.quintOut, onComplete: function(twn:FlxTween){hurtTween = null;}});
    }
}

function onNoteCreation(e) {
    if (e.noteType == "Hurt Note"){
		if (Assets.exists(Paths.image(e.noteSkinData.skin + "-hurt"))) {
			e.noteFrames = e.noteSkinData.skin + "-hurt";
		} else {
			e.noteFrames = "game/notes/default-hurt";
		}
		e.note.updateHitbox();
	}
}


function postCreate()
    if (hurtTween != null)
        hurtTween.cancel();