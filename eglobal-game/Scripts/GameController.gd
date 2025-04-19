class_name GameController extends Node

@export var world_2d : Node2D
@export var gui : Control
@export var transitionController: TransitionController

var current_2d_scene
var current_gui_scene

func _ready() -> void:
	Global.game_controller = self
	current_gui_scene = $GUILayer/GUI/Splash
	
func mock_player_data():
	Global.playerService.create_player()
	
func change_gui_scene(new_scene: Util.GUI_SCENES, delete: bool = false, keep_running: bool = false) -> void:
	transitionController.transition("fade out", 1)
	transitionController.visible = true
	await transitionController.animation_player.animation_finished
	if current_gui_scene != null:
		if delete:
			current_gui_scene.queue_free()
		elif keep_running:
			current_gui_scene.visible = false
		else:
			gui.remove_child(current_gui_scene)
	var new
	match new_scene:
		Util.GUI_SCENES.META:
			new = load(Util.MetaGUIScenePath).instantiate()
		Util.GUI_SCENES.BATTLE:
			new = load(Util.BattleGUIScenePath).instantiate()
	gui.add_child(new)
	current_gui_scene = new
	transitionController.transition("fade in", 1)
	transitionController.visible = false
	
func change_2d_scene(new_scene: Util.WORLD_SCENES):
	if current_2d_scene != null:
		current_2d_scene.queue_free()
	var new
	match new_scene:
		Util.WORLD_SCENES.META:
			new = load(Util.MetaScene).instantiate()
		Util.GUI_SCENES.BATTLE:
			new = load(Util.BattleScene).instantiate()
	
	world_2d.add_child(new)
	current_2d_scene = new
