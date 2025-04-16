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
var lerp_dorado : bool = false

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
			dialogue.say_custom("Ey pará, ¿Dónde esta mi oro? Sirena del orto devolvem-|willemdafoe|50")
			lerp_alpha = true
			_material1 = peine_dorado.get_active_material(0)
			_material2 = peine_feo.get_active_material(0)
			_material3 = sirena_mesh.get_active_material(0)
			_material4 = sirena_fea_mesh.get_active_material(0)
			timer_id = 3
			timer.start(1.8)
		3:
			sirena_fea.play_animation("Grab")
			timer_id = 4
			timer.start(5)
		4:
			lerp_dorado = true
			_material5 = dorado.get_active_material(0)
			timer_id = 5
			timer.start(5)
		5:
			fade_out = true
			timer_id = 6
			timer.start(2)
		6:
			dialogue.say_custom("Todavia no se si nada de esto fue real, tengo el dorado gigante que lo prueba supongo pero, a quien le voy a contar esto? me van a tratar de loco, o peor, de chanta. Por lo que averigue de las leyendas, la mayup maman es la madre del rio, y es generosa, pero solo mientras seas respetuoso con sus aguas.|player|51")

@onready var dialogue : EzDialogue = $"../DialogueBox"

@onready var dorado: MeshInstance3D = $"../Dorado/Cube"

var fade_out : bool = false
var _material1: StandardMaterial3D
var _material2: StandardMaterial3D
var _material3: StandardMaterial3D
var _material4: StandardMaterial3D
var _material5: StandardMaterial3D
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
			lerp_alpha = false
			opacity = 0
		return
	if lerp_dorado:
		opacity = min(1, opacity + delta * .3)
		_material5.albedo_color.a = lerp(0, 1, opacity)
		if opacity >= 1:
			lerp_dorado = false
		return
	if fade_out:
		color_rect.color.a += 1 * delta
		return

@onready var color_rect: ColorRect = $"../FadeOut/ColorRect"

func _on_timer_timeout() -> void:
	_play(timer_id)
