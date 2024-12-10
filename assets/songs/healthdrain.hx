//
function onDadHit(NoteHitEvent){
    if(Options.globalHealthDrain)
    {
        health = Math.max(0.001, health - 0.02);
    }
}
