@tool
class_name EzDialogue extends EzDialogueReader

@export var dialogues : Array[JSON]
@export var dialogue_voices : Array[AudioStream]
var current_dialogue : int = 0

@onready var label : Label = $Label
@onready var state = {}
@onready var timer: Timer = $AdvanceDialogueTimer
@onready var game_manager: GameManager = $".."
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

var ended : bool = false
var is_one_shot : bool = false

func _on_dialogue_generated(response: DialogueResponse) -> void:
	var text_parts = response.text.split("|")
	label.text = text_parts[0]
	
	if text_parts.size() > 1:
		var dialogue_voice_index = int(text_parts[1])
		if dialogue_voice_index < dialogue_voices.size():
			audio_player.stream = dialogue_voices[dialogue_voice_index]
			audio_player.play()
	
	if is_one_shot:
		return
	
	if response.text != "":
		is_one_shot = false
		timer.start(3)
	else:
		game_manager._ended_segment()
		audio_player.stop()
		current_dialogue += 1

func _on_timer_timeout() -> void:
	next()

func _start_next_dialogue():
	start_dialogue(dialogues[current_dialogue], state)
	timer.start(3)

func say_custom(text : String):
	is_one_shot = true
	label.text = text
	timer.start(3)
