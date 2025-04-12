class_name EndingSequence extends Node

@onready var willem_dafoe: PlayAnimation = $"../WillemDafoe"
@onready var peine_feo: MeshInstance3D = $"../WillemDafoe/Armature/Skeleton3D/PeineFeo"
@onready var peine_dorado: MeshInstance3D = $"../WillemDafoe/Armature/Skeleton3D/PeineDorado"
@onready var timer: Timer = $Timer
@onready var sirena: PlayAnimation = $"../Sirena"
@onready var sirena_fea: PlayAnimation = $"../Sirena fea"
@onready var sirena_mesh: MeshInstance3D = $"../Sirena/Armature/Skeleton3D/Anya"
@onready var sirena_fea_mesh: MeshInstance3D = $"../Sirena fea/Armature/Skeleton3D/Anya"

var timer_id : int = 0
var lerp_alpha : bool = false

func _play(value : int):
	match value:
		0:
			willem_dafoe.play_animation("Armature|GrabHeirloom")
			timer_id = 1
			timer.start(.9)
		1:
			timer_id = 2
			timer.start(.6)
			peine_dorado.visible = true
			peine_feo.visible = true
		2:
			lerp_alpha = true
			_material1 = peine_dorado.get_active_material(0)
			_material2 = peine_feo.get_active_material(0)
			_material3 = sirena_mesh.get_active_material(0)
			_material4 = sirena_fea_mesh.get_active_material(0)
			timer_id = 3
			timer.start(1)
		3:
			sirena_fea.play_animation("Grab")

var _material1: StandardMaterial3D
var _material2: StandardMaterial3D
var _material3: StandardMaterial3D
var _material4: StandardMaterial3D
var opacity : float = 0

func _process(delta: float) -> void:
	if lerp_alpha:
		opacity = min(1, opacity + delta * .5)
		_material1.albedo_color.a = lerp(1, 0, opacity)
		_material2.albedo_color.a = lerp(0, 1, opacity)
		_material3.albedo_color.a = lerp(1, 0, opacity)
		_material4.albedo_color.a = lerp(0, 1, opacity)
		if opacity == 1:
			sirena.visible = false
		pass

func _on_timer_timeout() -> void:
	print(timer_id)
	_play(timer_id)
