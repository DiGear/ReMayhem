function onPlayerHit(e)
    if (e.noteType == "Instakill Note")
        health = -.1;

function onDadHit(e)
    if (e.noteType == "Instakill Note")
        health = 2.1;

function onPlayerMiss(e) {
	if (e.noteType == "Instakill Note"){
		e.cancel();
		deleteNote(e.note);
	}
}

function onNoteCreation(e) {
    if (e.noteType == "Instakill Note"){
		if (Assets.exists(Paths.image(e.noteSkinData.skin + "-instakill"))) {
			e.noteFrames = e.noteSkinData.skin + "-instakill";
		} else {
			e.noteFrames = "game/notes/default-instakill";
		}
		e.note.updateHitbox();
	}
}
