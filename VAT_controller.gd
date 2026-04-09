@tool
extends Node

@export var target_mesh: MeshInstance3D

@export var startFrame:int = 0;
@export var endFrame:int = 0;
@export var frameRate:int = 0;
@export var loop:bool = false;

@export_tool_button("Play Animation","Play")
var play_button = _on_play_pressed

var time:float = 0.0;


func _on_play_pressed():

	# 🔥 Set instance uniforms
	target_mesh.set_instance_shader_parameter("instanceStartTime", time)
	target_mesh.set_instance_shader_parameter("frame_start",startFrame)
	target_mesh.set_instance_shader_parameter("frame_end", endFrame)
	target_mesh.set_instance_shader_parameter("loop_animation", loop)


func _on_button_button_down() -> void:
	call_deferred("_on_play_pressed")

func _precess(delta)->void:
	time += delta;
