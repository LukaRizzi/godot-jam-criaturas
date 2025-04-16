extends MeshInstance3D

func _process(delta: float) -> void:
	var mat := get_active_material(0)
	mat.uv1_offset.y = Time.get_ticks_usec() * .00000003
