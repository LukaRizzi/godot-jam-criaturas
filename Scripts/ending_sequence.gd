class_name EndingSequence extends Node

@onready var willem_dafoe: PlayAnimation = $"../WillemDafoe"
@onready var peine_feo: MeshInstance3D = $"../WillemDafoe/Armature/Skeleton3D/PeineFeo"
@onready var peine_dorado: MeshInstance3D = $"../WillemDafoe/Armature/Skeleton3D/PeineDorado"
@onready var timer: Timer = $Timer

var timer_id : int = 0
var lerp_alpha : bool = false

func _play(value : int):
	match value:
		0:
			willem_dafoe.play_animation("Armature|GrabHeirloom")
			timer_id = 1
			timer.start(1.2)
		1:
			timer_id = 2
			timer.start(.5)
			peine_dorado.visible = true
			peine_feo.visible = true
		2:
			lerp_alpha = true
			_material1 = peine_dorado.get_active_material(0)
			_material2 = peine_feo.get_active_material(0)

var _material1: StandardMaterial3D
var _material2: StandardMaterial3D
var opacity : float = 0

func _process(delta: float) -> void:
	if lerp_alpha:
		opacity = min(1, opacity + delta * .3)
		_material1.albedo_color.a = lerp(1, 0, opacity)
		_material2.albedo_color.a = lerp(0, 1, opacity)
		pass

func _on_timer_timeout() -> void:
	_play(timer_id)
