//
function onDadHit(NoteHitEvent) {
    switch (Options.globalHealthDrain) {
        case "off":
            return;
        case "normal":
            health = Math.max(0.001, health - 0.017);
        case "hard":
            health = Math.max(0.001, health - 0.021);
        case "unfair":
            health = Math.max(0.001, health - 0.03);
    }
}
