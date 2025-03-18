class_name GameController extends Node

@export var world_2d : Node2D
@export var gui : Control

var current_2d_scene
var current_gui_scene

func _ready() -> void:
	Global.game_controller = self
	current_gui_scene = $GUI/Splash


func change_gui_scene(new_scene: Util.SCENES, delete: bool = true, keep_running:bool = false) -> void:
	if current_gui_scene != null:
		if delete:
			current_gui_scene.queue_free()
		elif keep_running:
			current_gui_scene.visible = false
		else:
			gui.remove_child(current_gui_scene)
	var new
	match new_scene:
		Util.SCENES.META:
			new = load(Util.MetaScenePath).instantiate()
		Util.SCENES.BATTLE:
			new = load(Util.BattleScenePath).instantiate()
	gui.add_child(new)
	current_gui_scene = new
	
