extends Control
class_name MetaController

@onready var add_button: Button = $Button

func _ready() -> void:
	print("Ready")
	add_button.pressed.connect(_on_start_btn_pressed)

func _on_start_btn_pressed() -> void:
	Global.game_controller.change_gui_scene(Util.GUI_SCENES.BATTLE, true)
	Global.game_controller.change_2d_scene(Util.WORLD_SCENES.BATTLE)
	
	
	
