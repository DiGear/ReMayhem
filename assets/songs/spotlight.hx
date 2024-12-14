// funni syntax
var spotlight:FlxSprite;
function onEvent(eventData) {
    // check if the event is for the spotlight

    if (eventData.event.name == "Spotlight") {
        if (eventData.event.params[0] == false) { // spotlight disabled
            // destroy the spotlight
            if (spotlight != null) {
				// reset colors before destroying
				dad.setColorTransform(SONG.stage == "danny2" ? 0.5 : 1, SONG.stage == "danny2" ? 0.5 : 1, SONG.stage == "danny2" ? 0.8 : 1);
				boyfriend.setColorTransform(SONG.stage == "danny2" ? 0.5 : 1, SONG.stage == "danny2" ? 0.5 : 1, SONG.stage == "danny2" ? 0.8 : 1);
                spotlight.destroy();
                spotlight = null;
            }
        } else if (eventData.event.params[0] == true) { // spotlight enabled
            // generate the spotlight at the specified strumline
            var index = eventData.event.params[2];
            if (index >= 0 && index < strumLines.members.length) {
                // create a new spotlight if it doesn't exist
                if (spotlight == null) {
                    spotlight = new FlxSprite();
                    spotlight.loadGraphic(Paths.image("spotlight"));

                    // position and scale it (these are changeable in the event itself)
                    spotlight.x = strumLines.members[index].characters[0].x + eventData.event.params[3];
                    spotlight.y = strumLines.members[index].characters[0].y - 180 + eventData.event.params[4];
					spotlight.scale.set(eventData.event.params[5], eventData.event.params[5]);

                    spotlight.alpha = 0.5;
                    spotlight.camera = camGame;
                    add(spotlight);
                } else { // update the spotlight
                    spotlight.x = strumLines.members[index].characters[0].x + eventData.event.params[3];
                    spotlight.y = strumLines.members[index].characters[0].y - 180 + eventData.event.params[4];
					spotlight.scale.set(eventData.event.params[5], eventData.event.params[5]);
                }
                // parse the color and turn it into three values ranging from 0 to 1 for each channel
                var color = eventData.event.params[1];
                if (color != null) {
                    strumLines.members[index].characters[0].setColorTransform(
                        ((color >> 16) & 0xFF) / 255.0, // Red
                        ((color >> 8) & 0xFF) / 255.0, // Green
                        (color & 0xFF) / 255.0 // Blue
                    );
                }

				if (eventData.event.params[6] == true){
					// reset Dad tint
					strumLines.members[0].characters[0].setColorTransform(SONG.stage == "danny2" ? 0.5 : 1, SONG.stage == "danny2" ? 0.5 : 1, SONG.stage == "danny2" ? 0.8 : 1);
				}

				if (eventData.event.params[7] == true){
					// reset BF tint
					strumLines.members[1].characters[0].setColorTransform(SONG.stage == "danny2" ? 0.5 : 1, SONG.stage == "danny2" ? 0.5 : 1, SONG.stage == "danny2" ? 0.8 : 1);
				}
            }
        }
    }
}