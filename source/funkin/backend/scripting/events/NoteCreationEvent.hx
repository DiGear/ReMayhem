package funkin.backend.scripting.events;

import funkin.game.Character;
import funkin.game.NoteSkin;
import funkin.game.Note;

final class NoteCreationEvent extends CancellableEvent {
	/**
	 * Note that is being created
	 */
	public var note:Note;

	/**
	 * ID of the strum (from 0 to 3)
	 */
	public var strumID:Int;

	public var characters:Array<Character>;

	public var noteSkinData:NoteSkin;

	/**
	 * Note Type (ex: "My Super Cool Note", or "Mine")
	 */
	public var noteType:String;

	/**
	 * ID of the note type.
	 */
	public var noteTypeID:Int;

	/**
	 * ID of the player.
	 */
	public var strumLineID:Int;

	/**
	 * Whenever the note will need to be hit by the player
	 */
	public var mustHit:Bool;

	/**
	 * Note frames, if you only want to replace the frames.
	 */
	public var noteFrames:String;
	
	/**
	 * Note scale, if you only want to replace the scale.
	 */
	public var noteScale:Float;

	/**
	 * Sing animation suffix. "-alt" for alt anim or "" for normal notes.
	 */
	public var animSuffix:String;
}