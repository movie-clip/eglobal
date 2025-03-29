extends TextureRect
@onready var BattleButton = $"../TextureRect/BattleButton"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BattleButton.pressed.connect(self.on_battle_start)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_battle_start():
	print("on_battle_start")
