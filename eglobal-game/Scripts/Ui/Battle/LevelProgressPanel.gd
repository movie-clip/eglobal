extends Panel
class_name LevelProgressPanel

const  item_scene = preload("res://Scenes/Battle/UI/ProgressPointControl.tscn")
@onready var container: Control = $PointsControl

func _ready() -> void:
	create_item_progress_point(preload("res://Authoring/LevelProgress/FlagPoint.tres"), 0)
	create_item_progress_point(preload("res://Authoring/LevelProgress/ChestPoint.tres"), 1)
	create_item_progress_point(preload("res://Authoring/LevelProgress/SwordPoint.tres"), 2)
	create_item_progress_point(preload("res://Authoring/LevelProgress/SkullPoint.tres"), 3)

func _process(delta: float) -> void:
	pass

func create_item_progress_point(_ProgressPointData: ProgressPointData, _PosNum: int) -> void:
	var item = item_scene.instantiate()
	var pos_x: int = 3 + (_PosNum * 3) + (container.size.x / 4) * _PosNum
	var pos_y: int = container.size.y * 0.1
	item.data = _ProgressPointData
	item.set_position(Vector2(pos_x, pos_y))
	container.add_child(item)
