class_name FishingManager extends Camera3D

@export var mouse_sensitivity: float = 0.003
@export var fishes : Array[Node3D]
@export var fishes_in_bucket : Array[Node3D]

@onready var reel_sound: AudioStreamPlayer3D = $ReelSound
@onready var catch_sound: AudioStreamPlayer3D = $CatchSound
@onready var fish_showcase_timer: Timer = $FishShowcaseTimer
@onready var game_manager: GameManager = $".."
@onready var fish_indicator: MeshInstance3D = $"../FishIndicator"
@onready var bone : BoneAttachment3D = $FishingRod/Armature/Skeleton3D/BoneAttachment3D
@onready var skeleton_3d: Skeleton3D = $FishingRod/Armature/Skeleton3D

var cast_idx: int
var ogPos : Vector3 = Vector3.ZERO
var yaw: float = 0.0
var pitch: float = 0.0
var fishing : bool = false
var fishing_timer : float = 0
var fish_position : Vector3 = Vector3.ZERO
var fishing_angle : Vector3 = Vector3.ZERO
var og_fishing_angle : Vector3 = Vector3.ZERO
var mouse_movement_x : float = 0
var mouse_movement_y : float = 0
var can_fish : bool = false
var current_fish : int = 0
var played_sound : bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cast_idx = skeleton_3d.find_bone("Cast")  # Change "Hand" to your bone's name
	ogPos = bone.position

func _input(event):
	if event is InputEventMouseMotion:
		mouse_movement_x += event.relative.x
		mouse_movement_y += event.relative.y

func _process(delta):
	if fishes[current_fish].visible:
		fishes[current_fish].position = fishes[current_fish].position.move_toward(Vector3(0.167, -0.35, -3.722), 6 * delta)
	
	if fishing:
		if current_fish == -1:
			do_mermaid_sequence(delta)
			return
		
		var dist = global_position.distance_to(fish_position)
		if dist > 26:
			reel_sound.stop()
			fishing = false
			fish_indicator.visible = false
			game_manager._lost_fishing_minigame()
		else:
			if dist < 13:
				fishing_timer -= delta
				if fishing_timer <= 0:
					reel_sound.stop()
					catch_sound.play()
					fishing = false
					fish_indicator.visible = false
					can_fish = false
					game_manager._ended_segment()
					fishes[current_fish].visible = true
					fish_showcase_timer.start(3)
					return
		
		var forward_vec = -global_transform.basis.z
		forward_vec.y = 0
		forward_vec = forward_vec.normalized()
		
		if mouse_movement_x != 0:
			fish_position += forward_vec.cross(Vector3.UP).normalized() * mouse_movement_x * .1
		if mouse_movement_y != 0:
			fish_position += forward_vec * -mouse_movement_y * .1
		
		_update_fishing_spot(delta)
	else:
		yaw -= mouse_movement_x * mouse_sensitivity
		yaw = clamp(yaw, deg_to_rad(-110), deg_to_rad(80))
		pitch -= mouse_movement_y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-30), deg_to_rad(60)) # limit up/down look
		
		rotation.y = yaw
		rotation.x = pitch
		
		bone.position = lerp(bone.position, ogPos, delta * 20)
		if can_fish && Input.is_action_just_pressed("Click"):
			reel_sound.play()
			fishing = true
			fish_indicator.visible = true
			_update_fishing_spot(delta)
			fishing_timer = 5
			var distance = 15.0
			var forward_vec = -global_transform.basis.z
			forward_vec.y = 0
			forward_vec = forward_vec.normalized()
			fish_position = global_transform.origin + forward_vec * distance
			fish_position.y = -4.4
			fishing_angle = fish_position - global_position
			fishing_angle.y = 0
			fishing_angle = fishing_angle.normalized()
			og_fishing_angle = fishing_angle
			
			if current_fish == -1: #Setup Mermaid
				fishing_timer = 0
				fish_position = Vector3(-4, -4.4, -21.5) #-12.5 Y
				yaw = .29
				pitch = -.28
				rotation.y = yaw
				rotation.x = pitch
	mouse_movement_x = 0
	mouse_movement_y = 0

func _update_fishing_spot(delta):
	if cast_idx != -1 && fishing:
			var new_fishing_angle = fishing_angle.rotated(Vector3.UP, randf_range(-20 * delta, 20 * delta))
			if new_fishing_angle.dot(og_fishing_angle) > 0.2:
				fishing_angle = new_fishing_angle
			fish_position += fishing_angle * delta * 10;
			
			fish_indicator.global_position = fish_position
			bone.global_position = lerp(bone.global_position, fish_position, delta * 20);

func _on_fish_showcase_timer_timeout() -> void:
	fishes[current_fish].visible = false
	fishes_in_bucket[current_fish].visible = true

@onready var sirena: PlayAnimation = $"../Sirena"
@onready var sirena_fea: PlayAnimation = $"../Sirena fea"

func do_mermaid_sequence(delta):
	var dist = global_position.distance_to(fish_position)
	
	if dist < 16 && !played_sound:
		played_sound = true
		game_manager.dialogue.say_custom("MIRA, MIRA PIBE, AHÍ SALE, DALE QUE VOS PODÉS, TRAELA AL BOTE, TRAELA.|willemdafoe|48")
	
	if dist < 8.3:
		fishing_timer -= delta
		if fishing_timer <= 0:
			reel_sound.stop()
			game_manager.dialogue.say_custom("Vaaaamos pibe, pero mira lo que es ésto, es de oro sólido, y cómo es la cosa, ahora te pedimos un deseo?|willemdafoe|49")
			fishing = false
			fish_indicator.visible = false
			can_fish = false
			sirena_fea.global_position = sirena.global_position + global_transform.basis.z * .2 + Vector3(.2, 0, 0)
			sirena_fea.visible = true
			sirena_fea.play_animation("Move")
			sirena_fea.animation_player.seek(sirena.animation_player.current_animation_position, true)
			game_manager._ended_segment()
			return
	
	var forward_vec = fish_position - Vector3(-7.283, -6.638, -6.622)
	forward_vec.y = 0
	forward_vec = forward_vec.normalized()
	
	if mouse_movement_y != 0:
		fish_position += forward_vec * min(max(-2 * delta, -mouse_movement_y * .1), 0)
	
	mouse_movement_x = 0
	mouse_movement_y = 0
	
	sirena.global_position = fish_position
	sirena.global_position.y = lerp(-3.4,-12.5, dist / 20)
	fish_indicator.global_position = fish_position
	bone.global_position = lerp(bone.global_position, fish_position, delta * 20);
