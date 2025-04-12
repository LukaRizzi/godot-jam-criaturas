@tool
class_name EzDialogue extends EzDialogueReader

@export var dialogues : Array[JSON]
@export var dialogue_voices : Array[AudioStream]
var current_dialogue : int = 0

@onready var label : RichTextLabel = $Label
@onready var state = {}
@onready var timer: Timer = $WaitForNextTimer
@onready var game_manager: GameManager = $".."
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

var ended : bool = false
var is_one_shot : bool = false

func _on_dialogue_generated(response: DialogueResponse) -> void:
	var text_parts = response.text.split("|")
	label.text = "[font=res://Tillana/Tillana-Bold.ttf]" + text_parts[0]
	
	if text_parts.size() > 1:
		match text_parts[1]:
			"player":
				label.text = "[color=white]" + label.text
			"willemdafoe":
				label.text = "[color=yellow]" + label.text
				pass
	
	if text_parts.size() > 2:
		var dialogue_voice_index = int(text_parts[2])
		if dialogue_voice_index < dialogue_voices.size():
			audio_player.stream = dialogue_voices[dialogue_voice_index]
			audio_player.play()
	
	if response.text == "":
		current_dialogue += 1
		game_manager._ended_segment()

func _on_timer_timeout() -> void:
	next()

func _start_next_dialogue():
	is_one_shot = false
	start_dialogue(dialogues[current_dialogue], state)

func say_custom(text : String):
	is_one_shot = true
	var text_parts = text.split("|")
	label.text = "[font=res://Tillana/Tillana-Bold.ttf]" + text_parts[0]
	
	if text_parts.size() > 1:
		match text_parts[1]:
			"player":
				label.text = "[color=white]" + label.text
			"willemdafoe":
				label.text = "[color=yellow]" + label.text
				pass
	
	if text_parts.size() > 2:
		var dialogue_voice_index = int(text_parts[2])
		if dialogue_voice_index < dialogue_voices.size():
			audio_player.stream = dialogue_voices[dialogue_voice_index]
			audio_player.play()

func _on_audio_stream_player_3d_finished() -> void:
	if !is_one_shot:
		timer.start(.5)
