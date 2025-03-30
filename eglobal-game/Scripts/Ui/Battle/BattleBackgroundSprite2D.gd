extends Sprite2D
@onready var VisibleOnScreen: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready() -> void:
	VisibleOnScreen.screen_exited.connect(destroy_on_screen_exit, Object.ConnectFlags.CONNECT_ONE_SHOT)

func destroy_on_screen_exit() -> void:
	queue_free()
