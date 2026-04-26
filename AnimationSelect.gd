extends Node

signal animationSelected(AnimationClip:Dictionary)


@export_file("*.json") var json_file: String

@onready var options_button: OptionButton = $GUI/OptionButton

var animations: Dictionary = {}
var globalTime:float = 0.0;

func _ready():
	load_json()
	populate_options()

	options_button.item_selected.connect(_on_item_selected)


func load_json():
	if not FileAccess.file_exists(json_file):
		push_error("JSON file not found: " + json_file)
		return

	var file = FileAccess.open(json_file, FileAccess.READ)
	var json_text = file.get_as_text()

	var data = JSON.parse_string(json_text)
	if typeof(data) != TYPE_DICTIONARY:
		push_error("Invalid JSON format")
		return

	if not data.has("animations"):
		push_error("No 'animations' key in JSON")
		return

	animations = data["animations"]


func populate_options():
	options_button.clear()

	var keys = animations.keys()
	keys.sort() # optional: keeps things consistent

	options_button.add_separator("Select animation...")
	
	for anim_name in keys:
		var index = options_button.get_item_count()
		options_button.add_item(anim_name)
		options_button.set_item_metadata(index, animations[anim_name])

	options_button.select(0)

func _on_item_selected(index: int):
	var anim_name = options_button.get_item_text(index)
	var anim_data = options_button.get_item_metadata(index)
	
	emit_signal("animationSelected",anim_data)
	
	print("Selected:", anim_name)
	print("Start:", anim_data["startFrame"])
	print("End:", anim_data["endFrame"])
	print("FPS:", anim_data["framerate"])
	print("Looping:", anim_data["looping"])
	print("Blend:", anim_data["blend"])

func _process(delta)->void:
	globalTime += delta
	RenderingServer.global_shader_parameter_set("globalTime", globalTime)
