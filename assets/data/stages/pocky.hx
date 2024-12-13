//
import funkin.game.PlayState;


function postCreate() {
    //sayori.frames = Paths.getFrames("stages/pocky/sayobounce");
    //sayori.animation.addByPrefix("sayobounce", "sayobounce", 24, true);
    //sayori.animation.play("sayobounce");
	ezo.frames = Paths.getFrames("stages/pocky/ezo cheer");
    ezo.animation.addByPrefix("cheerNormal", "Ezo cheer N", 1, false);
	ezo.animation.addByPrefix("cheerWinning", "Ezo cheer W", 1, false);
	ezo.animation.addByPrefix("cheerLosing", "Ezo cheer L", 1, false);
	ezo.animation.addByPrefix("miss", "Ezo shock", 24, false);
    ezo.animation.play("cheerNormal");
	monika.frames = Paths.getFrames("stages/pocky/monika");
    monika.animation.addByPrefix("cheerNormal", "monika cheer n", 1, false);
	monika.animation.addByPrefix("cheerWinning", "monika cheer n", 1, false);
	monika.animation.addByPrefix("cheerLosing", "monika cheer n", 1, false);
    monika.animation.play("cheerNormal");
	
	hitoshi.frames = Paths.getFrames("stages/pocky/hitoshi");
	hitoshi.animation.addByPrefix("dance", "hitoshi dance", 1, false);
	hitoshi.animation.play("dance");
	
	
	ezo.scale.set(1.5,1.5);
	monika.scale.set(1.5,1.5);
	hitoshi.scale.set(1.5,1.5);
	
}

var frameNumberToJump:Int = 0;
var ezoBaseX:Int = 730;
var ezoMissAnimTimer:Float = -1;
function update(elapsed:Float) {

	//deal with hitoshis stuff
	//this behemoth basically maps the current pair of even and odd beats to a frame number
	frameNumberToJump=Std.int((Math.abs(Conductor.curBeatFloat)%2)*(12)); //hitoshi has 24 (/2=12) frames
	hitoshi.animation.play("dance", true, false, frameNumberToJump);
	
	//deal with ezos stuff
	frameNumberToJump=Std.int((Math.abs(Conductor.curBeatFloat)%2)*(10.5));  //ezo has 21 (/2=10.5) frames
	if (ezoMissAnimTimer < 0)
		{
			if (health >= 1.25)
				{
					ezo.animation.play("cheerWinning", true, false, frameNumberToJump);
					//Ezo's cheer W sprite is 16 pixels to the right, so just shift it 16 left if playing that animation
					ezo.x = ezoBaseX - 16;
				}
			else if (health >= 0.75)
				{
					ezo.animation.play("cheerNormal", true, false, frameNumberToJump);
					ezo.x = ezoBaseX;
				}
			else
				{
					ezo.animation.play("cheerLosing", true, false, frameNumberToJump);
					ezo.x = ezoBaseX;
				}
		}
	else
		{
			ezo.animation.play("miss", true, false, Std.int(ezoMissAnimTimer));
			ezo.x = ezoBaseX;
			ezoMissAnimTimer += 0.4;
			if (ezoMissAnimTimer >= 21.0)
				{
					ezoMissAnimTimer = -1.0;
				}
		}
		
	//deal with monikas stuff
	frameNumberToJump=(Std.int((Math.abs(Conductor.curBeatFloat)%2)*(10)) + 6) % 20;  //monika has 20 (/2=10) frames + 6 frames offset
	if (health >= 1.25)
		{
			monika.animation.play("cheerLosing", true, false, frameNumberToJump);
		}
	else if (health >= 0.75)
		{
			monika.animation.play("cheerNormal", true, false, frameNumberToJump);
		}
	else
		{
			monika.animation.play("cheerWinning", true, false, frameNumberToJump);
		}
}