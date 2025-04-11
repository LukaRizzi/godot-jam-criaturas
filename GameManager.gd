class_name GameManager extends Node3D

@onready var fishingManager: FishingManager = $Camera3D
@onready var dialogue: EzDialogue = $DialogueBox

var game_state : int = 0

func _ready() -> void:
	dialogue._start_next_dialogue()

func _ended_segment():
	game_state += 1
	_play_current_segment()

func _play_current_segment():
	match game_state:
		1:
			fishingManager.can_fish = true
		2:
			dialogue._start_next_dialogue()
