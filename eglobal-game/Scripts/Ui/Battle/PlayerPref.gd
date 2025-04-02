extends AnimatedSprite2D

var PlayerPos: Vector2
var IsRuning: bool
var RunTimer: Timer

func _ready() -> void:
	#Events.OnBattlaButtonClick.connect(on_click)
	update_player_pos()

func _process(delta: float) -> void:
	pass

func on_click():
	player_move()

func player_move()-> void:
	if(IsRuning == false):
		IsRuning = true
		play("run")
		var NewPlayerPos: Vector2 = PlayerPos + Vector2(1000, 0)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", NewPlayerPos, 3)
		tween.tween_callback(update_player_pos)

func  update_player_pos():
	PlayerPos = self.transform.get_origin()
	play("idle")
	IsRuning = false
	#Events.OnPlayerMoveFinished.emit(PlayerPos)
