extends Camera3D

@export var mouse_sensitivity: float = 0.003

@onready var fish_indicator: MeshInstance3D = $"../FishIndicator"
@onready var bone : BoneAttachment3D = $FishingRod/Armature/Skeleton3D/BoneAttachment3D
@onready var skeleton_3d: Skeleton3D = $FishingRod/Armature/Skeleton3D
var cast_idx: int

var yaw: float = 0.0
var pitch: float = 0.0

var fishing : bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cast_idx = skeleton_3d.find_bone("Cast")  # Change "Hand" to your bone's name

func _input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-20), deg_to_rad(80)) # limit up/down look
		rotation.y = yaw
		rotation.x = pitch

func _process(delta):
	if fishing:
		if cast_idx != -1 && fishing:
			var distance = 15.0
			var forward_vec = -global_transform.basis.z
			forward_vec.y = 0
			forward_vec = forward_vec.normalized()
			var forward_position = global_transform.origin + forward_vec * distance
			forward_position.y = -4.4;
			fish_indicator.global_position = forward_position
			bone.global_position = forward_position;
			if (Input.is_action_just_pressed("Click")):
				fishing = false
	else:
		if (Input.is_action_just_pressed("Click")):
				fishing = true

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
