class_name GameManager extends Node3D

@onready var fishingManager: FishingManager = $Camera3D
@onready var dialogue: EzDialogue = $DialogueBox
@onready var willem_dafoe: PlayAnimation = $WillemDafoe
@onready var sirena_fea: PlayAnimation = $"Sirena fea"
@onready var sirena: PlayAnimation = $Sirena

var game_state : int = 0

func _ready() -> void:
	dialogue._start_next_dialogue()
	willem_dafoe.play_animation("Armature|Sit")

func _ended_segment():
	game_state += 1
	_play_current_segment()

func _play_current_segment():
	match game_state:
		1:
			fishingManager.can_fish = true
			fishingManager.current_fish = 0
		2:
			dialogue._start_next_dialogue()

func _lost_fishing_minigame():
	dialogue.say_custom("ufa amigo no eras un pescador re capo vos? probá de nuevo, dale. asegurate que no se aleje lo suficiente tirando de la caña con el mouse.")
