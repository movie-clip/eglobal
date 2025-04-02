extends AnimatedSprite2D

var EnemyPos: Vector2
var IsRuning: bool

func _ready() -> void:
	play("idle")
	#Events.OnPlayerMoveFinished.connect(move_to_player)

func _process(delta: float) -> void:
	pass

func move_to_player(PlayerPos: Vector2) -> void:
	var pos: Vector2 = Vector2(PlayerPos.x + 1000, PlayerPos.y)
	global_position = pos
	if(IsRuning == false):
		IsRuning = true
		play("run")
		var NewPos: Vector2 = PlayerPos + Vector2(300, 0)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", NewPos, 5)
		tween.tween_callback(update_enemy_pos)

func  update_enemy_pos():
	EnemyPos = self.transform.get_origin()
	play("idle")
	IsRuning = false
