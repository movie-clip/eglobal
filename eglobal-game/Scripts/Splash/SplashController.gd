extends Node

@onready var start_btn: Button = $CenterContainer/PanelContainer/start_btn

func _ready() -> void:
	start_btn.connect("pressed", Callable(self, "_on_StartBattle_pressed"))

func _on_StartBattle_pressed() -> void:
	Global.game_controller.change_gui_scene(Util.SCENES.META, true)
