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

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cast_idx = skeleton_3d.find_bone("Cast")  # Change "Hand" to your bone's name
	ogPos = bone.position

func _input(event):
	if !fishing && event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-20), deg_to_rad(80)) # limit up/down look
		rotation.y = yaw
		rotation.x = pitch

func _process(delta):
	if fishing:
		fishing_timer -= delta
		if fishing_timer <= 0:
			fishing = false
			fish_indicator.visible = false
			pass
			
		_update_fishing_spot(delta)
	else:
		bone.position = lerp(bone.position, ogPos, delta * 20)
		if (Input.is_action_just_pressed("Click")):
				fishing = true
				fish_indicator.visible = true
				_update_fishing_spot(delta)
				fishing_timer = 5

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _update_fishing_spot(delta):
	if cast_idx != -1 && fishing:
			var distance = 15.0
			var forward_vec = -global_transform.basis.z
			forward_vec.y = 0
			forward_vec = forward_vec.normalized()
			var forward_position = global_transform.origin + forward_vec * distance
			forward_position.y = -4.4;
			fish_indicator.global_position = forward_position
			bone.global_position = lerp(bone.global_position, forward_position, delta * 20);
