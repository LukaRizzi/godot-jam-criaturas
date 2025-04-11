@tool
class_name EzDialogue extends EzDialogueReader

@export var dialogue_json: JSON

@onready var label : Label = $Label
@onready var state = {}
@onready var timer: Timer = $Timer

var ended : bool = false

func _ready():
	start_dialogue(dialogue_json, state)
	timer.start(3)

func _on_dialogue_generated(response: DialogueResponse) -> void:
	label.text = response.text
	if response.text != "":
		timer.start(3)
	else:
		#SE TERMINÓ EL DIÁLOGO, CONTINUAR
		pass

func _on_timer_timeout() -> void:
	print("timeout")
	next()
