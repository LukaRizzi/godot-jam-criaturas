class_name GameManager extends Node3D

@onready var fishingManager: FishingManager = $Camera3D
@onready var dialogue: EzDialogue = $DialogueBox
@onready var willem_dafoe: PlayAnimation = $WillemDafoe
@onready var sirena_fea: PlayAnimation = $"Sirena fea"
@onready var sirena: PlayAnimation = $Sirena
@onready var ending_sequence: EndingSequence = $EndingSequence
@onready var beer_can_in_hand: Node3D = $WillemDafoe/BeerCanInHand

var game_state : int = 0

func _ready() -> void:
	dialogue._start_next_dialogue()
	willem_dafoe.play_animation("Armature|Sit")

func _ended_segment():
	game_state += 1
	game_state = max(game_state, 3) # SACAR ESTO AL FINAL
	_play_current_segment()

func _play_current_segment():
	match game_state:
		1:
			fishingManager.can_fish = true
			fishingManager.current_fish = 0
		2:
			dialogue._start_next_dialogue()
		3:
			dialogue._start_next_dialogue()
		4:
			fishingManager.can_fish = true
			fishingManager.current_fish = 0
		5:
			dialogue._start_next_dialogue()
		6:
			fishingManager.can_fish = true
			fishingManager.current_fish = 0
		7:
			dialogue._start_next_dialogue()
		8:
			dialogue._start_next_dialogue()
		9:
			dialogue._start_next_dialogue()
		10:
			dialogue._start_next_dialogue()
		11:
			fishingManager.can_fish = true
			fishingManager.current_fish = 0	
		12:
			dialogue._start_next_dialogue()
		13: #sequencia final
			beer_can_in_hand.visible = false
			fishingManager.can_fish = true
			fishingManager.current_fish = -1
			sirena.visible = true
			sirena.play_animation("Move")			
		14:
			ending_sequence._play(0)

func _lost_fishing_minigame():
	dialogue.say_custom("ufa amigo no eras un pescador re capo vos? probá de nuevo, dale. asegurate que no se aleje lo suficiente tirando de la caña con el mouse.")
