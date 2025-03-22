extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self.on_click)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_click():
	var tween = get_tree().create_tween()
	#tween.tween_property(self, "modulate", Color.RED, 1)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.3)
	#tween.tween_property(self, "scale", Vector2(1, 1), 0.3)
	tween.chain().tween_property(self, "scale", Vector2(1, 1), 0.3)
	#tween.tween_callback(self.queue_free)
	Global.OnBattlaButtonClickEvent()
