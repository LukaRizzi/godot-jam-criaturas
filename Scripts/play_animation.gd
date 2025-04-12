class_name PlayAnimation extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_animation(anim_name : String):
	animation_player.play(anim_name)
