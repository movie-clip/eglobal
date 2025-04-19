extends Resource
class_name LevelConfiguration

@export var id: int
@export var level_scene: PackedScene
@export var back: Texture2D

@export var stages: Array[StageConfiguration] = []
