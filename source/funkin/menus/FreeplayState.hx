package funkin.menus;

import funkin.backend.chart.Chart;
import funkin.backend.chart.ChartData.ChartMetaData;
import haxe.io.Path;
import openfl.text.TextField;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import funkin.savedata.FunkinSave;
import funkin.backend.scripting.events.*;
// new freep imports
import flixel.FlxCamera;
import flixel.tweens.FlxTween;

using StringTools;

class FreeplayState extends MusicBeatState
{
	/**
	 * Array containing all of the songs metadatas
	 */
	public var songs:Array<ChartMetaData> = [];

	/**
	 * Currently selected song
	 */
	public var curSelected:Int = 0;

	/**
	 * Currently selected difficulty
	 */
	public var curDifficulty:Int = 1;

	/**
	 * Currently selected coop/opponent mode
	 */
	public var curCoopMode:Int = 0;

	/**
	 * Text containing the score info (PERSONAL BEST: 0)
	 */
	public var scoreText:FlxText;

	/**
	 * Text containing the current coop/opponent mode ([TAB] Co-Op mode)
	 */
	public var coopText:FlxText;

	/**
	 * Currently lerped score. Is updated to go towards `intendedScore`.
	 */
	public var lerpScore:Int = 0;

	/**
	 * Destination for the currently lerped score.
	 */
	public var intendedScore:Int = 0;

	/**
	 * Assigned FreeplaySonglist item.
	 */
	public var songList:FreeplaySonglist;

	/**
	 * Black background around the score, the difficulty text and the co-op text.
	 */
	public var scoreBG:FlxSprite;

	/**
	 * Background.
	 */
	public var bg:FlxSprite;

	/**
	 * Whenever the player can navigate and select
	 */
	public var canSelect:Bool = true;

	/**
	 * Group containing all of the alphabets
	 */
	public var grpSongs:FlxTypedGroup<FlxText>;

	/**
	 * Whenever the currently selected song is playing.
	 */
	public var curPlaying:Bool = false;

	/**
	 * FlxInterpolateColor object for smooth transition between Freeplay colors.
	 */
	public var interpColor:FlxInterpolateColor;

	// this is for the new freeplay menu stuff
	var separator:FlxSprite;
	var __lastDifficultyTween:FlxTween;
	var songListCamera:FlxCamera;
	var onTopCamera:FlxCamera;

	// stage and char scale configs
	public var stageScale:Float = 1;
	public var charScale:Float = 0.66;

	// public vars for the new freeplay menu stuff
	public var difficultySprites:Map<String, FlxSprite> = [];
	public var leftArrow:FlxSprite;
	public var rightArrow:FlxSprite;
	public var leftStage:FlxSprite;
	public var leftChar:FlxSprite;

	// this is fucking terrible btw
	public function getCharacterValues(displayName:String):Array<Dynamic>
	{
		return switch (displayName)
		{
			// Song Names [Character, M-Character, Stage, Char X, Char Y, M-Char X, M-Char Y]
			case "Chronokinesis", "Stargazer", "Singularity", "This One's Final Hours": ["danny", "danny-m", "danny1", 66, 120, 66, 120];
			case "Leffrey", "Leffrey's Baja Rap": ["leffrey", "jeffrey", "taco", 35, -20, 35, -18];
			case "ezo dummy", "November": ["ezo", "ezo", "ezo", 92, -57, 92, -57];
			case "Pickletensor", "Overclocked": ["dad", "dad", "default", 28, -30, 28, -30];
			default: return ["dad", "dad", "default", 28, -30, 28, -30];
		};
	}

	override function create()
	{
		CoolUtil.playMenuSong();
		songList = FreeplaySonglist.get();
		songs = songList.songs;

		for (k => s in songs)
		{
			if (s.name == Options.freeplayLastSong)
			{
				curSelected = k;
			}
		}
		if (songs[curSelected] != null)
		{
			for (k => diff in songs[curSelected].difficulties)
			{
				if (diff == Options.freeplayLastDifficulty)
				{
					curDifficulty = k;
				}
			}
		}

		DiscordUtil.call("onMenuLoaded", ["Freeplay"]);

		super.create();

		// i replaced the bgsprite here
		bg = new FlxSprite(0, 0).loadAnimatedGraphic(Paths.image('menus/freep/wall'));
		if (songs.length > 0)
			bg.color = songs[0].color;
		bg.antialiasing = true;
		add(bg);

		// this entire cam def is new and im using it to make the menu items scroll
		songListCamera = new FlxCamera(0, 0, 1280, 720);
		songListCamera.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(songListCamera, false);

		// this is so the score and diff overlay is on top
		onTopCamera = new FlxCamera(0, 0, 1280, 720);
		onTopCamera.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(onTopCamera, false);

		// this now a FlxText group rather than alphabet group
		grpSongs = new FlxTypedGroup<FlxText>();
		add(grpSongs);

		// ALL OF THIS is rewritten basically
		for (i in 0...songs.length)
		{
			var songText = new FlxText(560, (75 * i) + 30, 0, songs[i].displayName);
			songText.setFormat(Paths.font("vcr.ttf"), 52, FlxColor.WHITE, RIGHT);
			songText.setBorderStyle(OUTLINE, FlxColor.BLACK, 4, 100);
			songText.alpha = 0.45;
			songText.camera = songListCamera;
			grpSongs.add(songText);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 17, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		scoreText.camera = onTopCamera;

		scoreBG = new FlxSprite(0, 0).makeGraphic(1280, 100, 0xFF000000);
		scoreBG.alpha = 0.6;
		scoreBG.camera = onTopCamera;
		add(scoreBG);

		// DUMBASS ARROWS (from story menu)
		var assets = Paths.getFrames('menus/storymenu/assets');
		var directions = ["left", "right"];

		leftArrow = new FlxSprite((FlxG.width / 2 + 200) / 2, (scoreBG.y / 2) + 7);
		rightArrow = new FlxSprite((FlxG.width / 2 + 200), (scoreBG.y / 2) + 7);
		for (k => arrow in [leftArrow, rightArrow])
		{
			var dir = directions[k];

			arrow.frames = assets;
			arrow.animation.addByPrefix('idle', 'arrow $dir');
			arrow.animation.addByPrefix('press', 'arrow push $dir', 24, false);
			arrow.animation.play('idle');
			arrow.antialiasing = true;
			arrow.camera = onTopCamera;
			add(arrow);
		}

		// mmmmmmmmmmmmmnmnmnnmnmnm.,.l.,
		for (i in 0...songs.length)
		{
			var song = songs[i];

			for (e in song.difficulties)
			{
				var le = e.toLowerCase();
				if (difficultySprites[le] == null)
				{
					var diffSprite = new FlxSprite(leftArrow.x + leftArrow.width, leftArrow.y);
					diffSprite.loadAnimatedGraphic(Paths.image('menus/storymenu/difficulties/${le}'));
					diffSprite.setUnstretchedGraphicSize(Std.int(rightArrow.x - leftArrow.x - leftArrow.width), Std.int(leftArrow.height), false, 1);
					diffSprite.antialiasing = true;
					diffSprite.scrollFactor.set();
					diffSprite.camera = onTopCamera;
					add(diffSprite);

					difficultySprites[le] = diffSprite;
				}
			}
		}

		coopText = new FlxText(FlxG.width * 0.7, scoreText.y + 35, 0, "[TAB] Solo", 24);
		coopText.font = scoreText.font;
		coopText.camera = onTopCamera;
		add(coopText);

		add(scoreText);

		changeSelection(0, true);
		changeDiff(0, true);
		changeCoopMode(0, true);

		interpColor = new FlxInterpolateColor(bg.color);

		// init + load the stage and char
		var song = songs[curSelected];
		var characterValues = getCharacterValues(song.displayName); // Character, M-Character, Stage, Char X, Char Y, M-Char X, M-Char Y

		var character = characterValues[0];
		var mCharacter = characterValues[1];
		var stageGraphic = characterValues[2];
		var charX = characterValues[3];
		var charY = characterValues[4];
		var mCharX = characterValues[5];
		var mCharY = characterValues[6];

		if (leftStage != null)
		{
			leftStage.kill();
		}

		leftStage = new FlxSprite(0, 0).loadAnimatedGraphic(Paths.image('menus/freep/stages/' + stageGraphic));
		leftStage.antialiasing = true;
		add(leftStage);

		if (leftChar != null) 
		{
			leftChar.kill();
		}

		leftChar = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/freep/chara/' + (song.difficulties[curDifficulty] == "Mayhem" ? mCharacter : character)));
		leftChar.scale.set(charScale, charScale);
		leftChar.x = song.difficulties[curDifficulty] == "Mayhem" ? mCharX : charX;
		leftChar.y = song.difficulties[curDifficulty] == "Mayhem" ? mCharY : charY;
		leftChar.antialiasing = true;
		add(leftChar);

		// squiggly separator
		separator = new FlxSprite(477, 0).loadAnimatedGraphic(Paths.image('menus/freep/bolt'));
		separator.antialiasing = true;
		separator.camera = onTopCamera;
		add(separator);
	}

	#if PRELOAD_ALL
	/**
	 * How much time a song stays selected until it autoplays.
	 */
	public var timeUntilAutoplay:Float = 0.25;

	/**
	 * Whenever the song autoplays when hovered over.
	 */
	public var disableAutoPlay:Bool = false;

	/**
	 * Whenever the autoplayed song gets async loaded.
	 */
	public var disableAsyncLoading:Bool = #if desktop false #else true #end;

	/**
	 * Time elapsed since last autoplay. If this time exceeds `timeUntilAutoplay`, the currently selected song will play.
	 */
	public var autoplayElapsed:Float = 0;

	/**
	 * Whenever the currently selected song instrumental is playing.
	 */
	public var songInstPlaying:Bool = true;

	/**
	 * Path to the currently playing song instrumental.
	 */
	public var curPlayingInst:String = null;
	#end

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music != null && FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
		}

		lerpScore = Math.floor(lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		if (canSelect)
		{
			changeSelection((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0) - FlxG.mouse.wheel);
			changeDiff((controls.LEFT_P ? -1 : 0) + (controls.RIGHT_P ? 1 : 0));
			changeCoopMode((FlxG.keys.justPressed.TAB ? 1 : 0));
			updateOptionsAlpha();
		}

		scoreText.text = "HIGHSCORE:" + lerpScore;
		scoreBG.updateHitbox();

		scoreText.x = coopText.x = scoreBG.x + 4;

		interpColor.fpsLerpTo(songs[curSelected].parsedColor, 0.0625);
		bg.color = interpColor.color;

		#if PRELOAD_ALL
		var dontPlaySongThisFrame = false;
		autoplayElapsed += elapsed;
		if (!disableAutoPlay && !songInstPlaying && (autoplayElapsed > timeUntilAutoplay || FlxG.keys.justPressed.SPACE))
		{
			if (curPlayingInst != (curPlayingInst = Paths.inst(songs[curSelected].name, songs[curSelected].difficulties[curDifficulty])))
			{
				var huh:Void->Void = function() FlxG.sound.playMusic(curPlayingInst, 0);
				if (!disableAsyncLoading)
					Main.execAsync(huh);
				else
					huh();
			}
			songInstPlaying = true;
			if (disableAsyncLoading)
				dontPlaySongThisFrame = true;
		}
		#end

		// arrow shit
		if (leftArrow != null && leftArrow.exists)
			leftArrow.animation.play(controls.LEFT ? 'press' : 'idle');
		if (rightArrow != null && rightArrow.exists)
			rightArrow.animation.play(controls.RIGHT ? 'press' : 'idle');

		if (controls.BACK)
		{
			CoolUtil.playMenuSFX(CANCEL, 0.7);
			FlxG.switchState(new MainMenuState());
		}

		#if sys
		if (FlxG.keys.justPressed.EIGHT && Sys.args().contains("-livereload"))
			convertChart();
		#end

		if (controls.ACCEPT #if PRELOAD_ALL && !dontPlaySongThisFrame #end)
			select();
	}

	var __opponentMode:Bool = false;
	var __coopMode:Bool = false;

	function updateCoopModes()
	{
		__opponentMode = false;
		__coopMode = false;
		if (songs[curSelected].coopAllowed && songs[curSelected].opponentModeAllowed)
		{
			__opponentMode = curCoopMode % 2 == 1;
			__coopMode = curCoopMode >= 2;
		}
		else if (songs[curSelected].coopAllowed)
		{
			__coopMode = curCoopMode == 1;
		}
		else if (songs[curSelected].opponentModeAllowed)
		{
			__opponentMode = curCoopMode == 1;
		}
	}

	/**
	 * Selects the current song.
	 */
	public function select()
	{
		updateCoopModes();

		if (songs[curSelected].difficulties.length <= 0)
			return;

		var event = event("onSelect",
			EventManager.get(FreeplaySongSelectEvent)
				.recycle(songs[curSelected].name, songs[curSelected].difficulties[curDifficulty], __opponentMode, __coopMode));

		if (event.cancelled)
			return;

		Options.freeplayLastSong = songs[curSelected].name;
		Options.freeplayLastDifficulty = songs[curSelected].difficulties[curDifficulty];

		PlayState.loadSong(event.song, event.difficulty, event.opponentMode, event.coopMode);
		FlxG.switchState(new PlayState());
	}

	public function convertChart()
	{
		trace('Converting ${songs[curSelected].name} (${songs[curSelected].difficulties[curDifficulty]}) to Codename format...');
		var chart = Chart.parse(songs[curSelected].name, songs[curSelected].difficulties[curDifficulty]);
		Chart.save('${Main.pathBack}assets/songs/${songs[curSelected].name}', chart, songs[curSelected].difficulties[curDifficulty].toLowerCase());
	}

	// hamgurber
	var __oldDiffName = null;

	public function changeDiff(change:Int = 0, force:Bool = false)
	{
		if (change == 0 && !force)
			return;

		var curSong = songs[curSelected];
		var validDifficulties = curSong.difficulties.length > 0;
		var event = event("onChangeDiff",
			EventManager.get(MenuChangeEvent)
				.recycle(curDifficulty, validDifficulties ? FlxMath.wrap(curDifficulty + change, 0, curSong.difficulties.length - 1) : 0, change));

		if (event.cancelled)
			return;
		curDifficulty = event.value;

		var newDiffName = validDifficulties ? curSong.difficulties[curDifficulty].toLowerCase() : "standard";
		if (__oldDiffName != (__oldDiffName = newDiffName))
		{
			for (e in difficultySprites)
				e.visible = false;

			var diffSprite = difficultySprites[newDiffName];
			if (diffSprite != null)
			{
				diffSprite.visible = true;

				if (__lastDifficultyTween != null)
					__lastDifficultyTween.cancel();
				diffSprite.alpha = 0;
				diffSprite.y = leftArrow.y - 15;

				__lastDifficultyTween = FlxTween.tween(diffSprite, {y: leftArrow.y, alpha: 1}, 0.07);
			}
		}
		updateScore();

		var song = songs[curSelected];
		var characterValues = getCharacterValues(song.displayName); // Character, M-Character, Stage, Char X, Char Y, M-Char X, M-Char Y

		var character = characterValues[0];
		var mCharacter = characterValues[1];
		var stageGraphic = characterValues[2];
		var charX = characterValues[3];
		var charY = characterValues[4];
		var mCharX = characterValues[5];
		var mCharY = characterValues[6];

		if (leftStage != null)
		{
			leftStage.kill();
		}

		leftStage = new FlxSprite(0, 0).loadAnimatedGraphic(Paths.image('menus/freep/stages/' + stageGraphic));
		leftStage.antialiasing = true;
		add(leftStage);

		if (leftChar != null) 
		{
			leftChar.kill();
		}

		leftChar = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/freep/chara/' + (song.difficulties[curDifficulty] == "Mayhem" ? mCharacter : character)));
		leftChar.scale.set(charScale, charScale);
		leftChar.x = song.difficulties[curDifficulty] == "Mayhem" ? mCharX : charX;
		leftChar.y = song.difficulties[curDifficulty] == "Mayhem" ? mCharY : charY;
		leftChar.antialiasing = true;
		add(leftChar);
	}

	function updateScore()
	{
		if (songs[curSelected].difficulties.length <= 0)
		{
			intendedScore = 0;
			return;
		}
		updateCoopModes();
		var changes:Array<HighscoreChange> = [];
		if (__coopMode)
			changes.push(CCoopMode);
		if (__opponentMode)
			changes.push(COpponentMode);
		var saveData = FunkinSave.getSongHighscore(songs[curSelected].name, songs[curSelected].difficulties[curDifficulty], changes);
		intendedScore = saveData.score;
	}

	/**
	 * Array containing all labels for Co-Op / Opponent modes.
	 */
	public var coopLabels:Array<String> = [
		"[TAB] Default",
		"[TAB] Opponent Mode",
		"[TAB] 2P Mode",
		"[TAB] 2P Mode (Switch Sides)"
	];

	/**
	 * Change the current coop mode context.
	 * @param change How much to change
	 * @param force Force the change, even if `change` is equal to 0.
	 */
	public function changeCoopMode(change:Int = 0, force:Bool = false)
	{
		if (change == 0 && !force)
			return;
		if (!songs[curSelected].coopAllowed && !songs[curSelected].opponentModeAllowed)
			return;

		var bothEnabled = songs[curSelected].coopAllowed && songs[curSelected].opponentModeAllowed;
		var event = event("onChangeCoopMode",
			EventManager.get(MenuChangeEvent).recycle(curCoopMode, FlxMath.wrap(curCoopMode + change, 0, bothEnabled ? 3 : 1), change));

		if (event.cancelled)
			return;

		curCoopMode = event.value;

		updateScore();

		if (bothEnabled)
		{
			coopText.text = coopLabels[curCoopMode];
		}
		else
		{
			coopText.text = coopLabels[curCoopMode * (songs[curSelected].coopAllowed ? 2 : 1)];
		}
	}

	/**
	 * Change the current selection.
	 * @param change How much to change
	 * @param force Force the change, even if `change` is equal to 0.
	 */
	public function changeSelection(change:Int = 0, force:Bool = false)
	{
		if (change == 0 && !force)
			return;

		var bothEnabled = songs[curSelected].coopAllowed && songs[curSelected].opponentModeAllowed;
		var event = event("onChangeSelection",
			EventManager.get(MenuChangeEvent).recycle(curSelected, FlxMath.wrap(curSelected + change, 0, songs.length - 1), change));
		if (event.cancelled)
			return;

		curSelected = event.value;
		if (event.playMenuSFX)
			CoolUtil.playMenuSFX(SCROLL, 0.7);

		changeDiff(0, true);

		#if PRELOAD_ALL
		autoplayElapsed = 0;
		songInstPlaying = false;
		#end

		coopText.visible = songs[curSelected].coopAllowed || songs[curSelected].opponentModeAllowed;

		var song = songs[curSelected];
		var characterValues = getCharacterValues(song.displayName); // Character, M-Character, Stage, Char X, Char Y, M-Char X, M-Char Y

		var character = characterValues[0];
		var mCharacter = characterValues[1];
		var stageGraphic = characterValues[2];
		var charX = characterValues[3];
		var charY = characterValues[4];
		var mCharX = characterValues[5];
		var mCharY = characterValues[6];

		if (leftStage != null)
		{
			leftStage.kill();
		}

		leftStage = new FlxSprite(0, 0).loadAnimatedGraphic(Paths.image('menus/freep/stages/' + stageGraphic));
		leftStage.antialiasing = true;
		add(leftStage);

		if (leftChar != null) 
		{
			leftChar.kill();
		}

		leftChar = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/freep/chara/' + (song.difficulties[curDifficulty] == "Mayhem" ? mCharacter : character)));
		leftChar.scale.set(charScale, charScale);
		leftChar.x = song.difficulties[curDifficulty] == "Mayhem" ? mCharX : charX;
		leftChar.y = song.difficulties[curDifficulty] == "Mayhem" ? mCharY : charY;
		leftChar.antialiasing = true;
		add(leftChar);
	}

	function updateOptionsAlpha()
	{
		var event = event("onUpdateOptionsAlpha", EventManager.get(FreeplayAlphaUpdateEvent).recycle(0.6, 0.45, 1, 1, 0.25));
		if (event.cancelled)
			return;

		// alpha shit
		for (i in 0...grpSongs.members.length)
		{
			var item = cast(grpSongs.members[i], FlxText);
			if (item != null)
			{
				item.alpha = (i == curSelected) ? 1 : 0.45;
			}
		}

		// make the items scroll
		var target = cast(grpSongs.members[curSelected], FlxText);
		if (target != null)
		{
			var targetY = target.y - songListCamera.height / 2;
			var speed = 0.1;
			songListCamera.scroll.y += (targetY - songListCamera.scroll.y) * speed;

			// snap so it dont jitter
			if (Math.abs(songListCamera.scroll.y - targetY) < 0.1)
			{
				songListCamera.scroll.y = targetY;
			}
		}
	}
}

class FreeplaySonglist
{
	public var songs:Array<ChartMetaData> = [];

	public function new()
	{
	}

	public function getSongsFromSource(source:funkin.backend.assets.AssetsLibraryList.AssetSource, useTxt:Bool = true)
	{
		var path:String = Paths.txt('freeplaySonglist');
		var songsFound:Array<String> = [];
		if (useTxt && Paths.assetsTree.existsSpecific(path, "TEXT", source))
		{
			songsFound = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		}
		else
		{
			songsFound = Paths.getFolderDirectories('songs', false, source);
		}

		if (songsFound.length > 0)
		{
			for (s in songsFound)
				songs.push(Chart.loadChartMeta(s, "normal", source == MODS));
			return false;
		}
		return true;
	}

	public static function get(useTxt:Bool = true)
	{
		var songList = new FreeplaySonglist();

		if (songList.getSongsFromSource(MODS, useTxt))
			songList.getSongsFromSource(SOURCE, useTxt);

		return songList;
	}
}
