extends Node3D

var og_pos : Vector3

func _ready() -> void:
	og_pos = global_position

func _process(delta: float) -> void:
	global_position = og_pos + Vector3.UP * sin(Time.get_ticks_usec() * .000001) * .2
