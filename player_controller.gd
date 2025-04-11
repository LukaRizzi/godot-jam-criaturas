extends Camera3D

@export var mouse_sensitivity: float = 0.003

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

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cast_idx = skeleton_3d.find_bone("Cast")  # Change "Hand" to your bone's name
	ogPos = bone.position

func _input(event):
	if event is InputEventMouseMotion:
		mouse_movement_x += event.relative.x
		mouse_movement_y += event.relative.y

func _process(delta):
	if fishing:
		var dist = global_position.distance_to(fish_position)
		if dist > 26:
			#PERDISTE
			print("perdiste")
			fishing = false
			fish_indicator.visible = false
		else:
			if dist < 13:
				fishing_timer -= delta
				if fishing_timer <= 0:
					#GANASTEEE
					print("ganaste")
					fishing = false
					fish_indicator.visible = false
					pass
		
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
		yaw = clamp(yaw, deg_to_rad(-160), deg_to_rad(80))
		pitch -= mouse_movement_y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-20), deg_to_rad(80)) # limit up/down look
		
		rotation.y = yaw
		rotation.x = pitch
		
		bone.position = lerp(bone.position, ogPos, delta * 20)
		if (Input.is_action_just_pressed("Click")):
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
	mouse_movement_x = 0
	mouse_movement_y = 0

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _update_fishing_spot(delta):
	if cast_idx != -1 && fishing:
			var new_fishing_angle = fishing_angle.rotated(Vector3.UP, randf_range(-20 * delta, 20 * delta))
			if new_fishing_angle.dot(og_fishing_angle) > 0.2:
				fishing_angle = new_fishing_angle
			fish_position += fishing_angle * delta * 10;
			
			fish_indicator.global_position = fish_position
			bone.global_position = lerp(bone.global_position, fish_position, delta * 20);
