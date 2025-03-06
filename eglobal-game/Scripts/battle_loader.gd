extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
const BATTLE_SCENE_PATH: String = "res://Scenes/Battle.tscn"
var loading_in_progress: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ResourceLoader.load_threaded_request(BATTLE_SCENE_PATH, "PackedScene", false)
	loading_in_progress = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if loading_in_progress:
		var status = ResourceLoader.load_threaded_get_status(BATTLE_SCENE_PATH)

		match status:
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
				# Animate your progress bar (indefinite or a slow fill)
				progress_bar.value = fmod(progress_bar.value + delta * 20.0, 100.0)

			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
				# 3) Once loaded, retrieve the resource and switch scenes
				progress_bar.value = 100.0
				var res = ResourceLoader.load_threaded_get(BATTLE_SCENE_PATH)
				if res:
					var scene = res as PackedScene
					get_tree().change_scene_to_packed(scene)
				else:
					push_error("Failed to load scene resource.")
				loading_in_progress = false

			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED:
				push_error("Loading FAILED for: %s" % BATTLE_SCENE_PATH)
				loading_in_progress = false

			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE:
				loading_in_progress = false
