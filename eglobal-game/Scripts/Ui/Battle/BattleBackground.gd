extends Node2D
const  SceneBackground = preload("res://Scenes/battle_background_sprite_2d.tscn")
const  SceneEnemy = preload("res://Scenes/EnemyPref.tscn")
var CurrentPosX: int = 2250
var CurrentPosY: int = 400
var CurrentScenesCount: int = 0

func _ready() -> void:
	#print(SpriteBackground.get_rect().size.x)
	spawn_background()
	#Events.OnBattlaButtonClick.connect(spawn_background)
	#Events.OnBattlaButtonClick.connect(spawn_enemy)

func spawn_background() -> void:
	CurrentScenesCount += 1
	var pos: Vector2 = Vector2(CurrentPosX * CurrentScenesCount, CurrentPosY)
	var obj = SceneBackground.instantiate()
	add_child(obj)
	obj.global_position = pos
	print("spawn bg " + str(CurrentScenesCount))

func spawn_enemy() -> void:
	var pos: Vector2 = Vector2(9999, 9999)
	var obj = SceneEnemy.instantiate()
	add_child(obj)
	obj.global_position = pos
	print("spawn enemy")
