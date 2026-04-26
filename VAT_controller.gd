extends Node

signal animationEnded

@export var blendAvailable:bool = false;
@onready var target_mesh: MeshInstance3D = $Knight_vat
var anim_time = 0.0
var animend_Time = INF
var currentClip = null;
	
func runAnimation(AnimationClip:Dictionary) -> void:
	if !blendAvailable: #ADVANCED VAT SHADER WITHOUT BLENDING OPTION
		currentClip = AnimationClip
	
	#SET BLEND CLIP
	target_mesh.set_instance_shader_parameter("frame_start",int(currentClip["startFrame"]))
	target_mesh.set_instance_shader_parameter("frame_end", int(currentClip["endFrame"]))
	target_mesh.set_instance_shader_parameter("loop_animation", AnimationClip["looping"])

	#SET NEXT CLIP
	target_mesh.set_instance_shader_parameter("blend_frame_start",int(AnimationClip["startFrame"]))
	target_mesh.set_instance_shader_parameter("blend_frame_end", int(AnimationClip["endFrame"]))
	
	##TODO BLEND-IN or BLEND-OUT
	if( !AnimationClip["blend"] || !currentClip["blend"]):
		target_mesh.set_instance_shader_parameter("blend_start", 0.0)#NO BLEND
	else:
		target_mesh.set_instance_shader_parameter("blend_start", anim_time)
	
	if( !AnimationClip["looping"]):
		animend_Time =(anim_time+(AnimationClip["endFrame"]-AnimationClip["startFrame"]))/AnimationClip["framerate"]
		target_mesh.set_instance_shader_parameter("instanceStartTime", anim_time)

#TODO 
func _process(delta: float) -> void:#Update only if waiting for event
	anim_time += delta #CHANGE TO GLOBAL TIME
	if(anim_time >= animend_Time):
		emit_signal("animationEnded");
		animend_Time = INF#set update(false) insted
		print("animEnded")

func _on_main_scene_animation_selected(AnimationClip: Dictionary) -> void:
	if(currentClip == null):
		currentClip = AnimationClip
	
	runAnimation(AnimationClip)
	currentClip = AnimationClip
