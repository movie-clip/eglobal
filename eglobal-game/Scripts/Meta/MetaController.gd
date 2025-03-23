extends Control

@onready var start_btn: Button = $BottomArea/VBoxContainer/HBoxContainer/start_btn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_btn.connect("pressed", Callable(self, "_on_StartBattle_pressed"))


func _on_StartBattle_pressed() -> void:
	Global.game_controller.change_gui_scene(Util.SCENES.BATTLE, true)
