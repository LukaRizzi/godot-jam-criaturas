@tool
class_name EzDialogue extends EzDialogueReader

@export var dialogues : Array[JSON]
var current_dialogue : int = 0

@onready var label : Label = $Label
@onready var state = {}
@onready var timer: Timer = $Timer
@onready var game_manager: GameManager = $".."

var ended : bool = false

func _on_dialogue_generated(response: DialogueResponse) -> void:
	label.text = response.text
	if response.text != "":
		timer.start(3)
	else:
		game_manager._ended_segment()

func _on_timer_timeout() -> void:
	next()

func _start_next_dialogue():
	start_dialogue(dialogues[current_dialogue], state)
	current_dialogue += 1
	timer.start(3)
