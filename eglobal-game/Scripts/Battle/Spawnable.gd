extends Resource
class_name Spawnable

@export var scene: PackedScene
@export var texture: Texture2D

func get_scene() -> PackedScene:
	return scene
