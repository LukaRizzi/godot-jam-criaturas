extends Node3D

var og_pos : Vector3
@export var magnitude : float = 1
@export var timing : float = 1

func _ready() -> void:
	og_pos = position

func _process(delta: float) -> void:
	position = og_pos + Vector3.UP * sin(Time.get_ticks_usec() * .000001 * timing) * .2 * magnitude
