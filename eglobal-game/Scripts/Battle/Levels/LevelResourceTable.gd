extends Resource
class_name LevelResourceTable

@export var level_configs: Array = [LevelConfiguration]

func get_config(id: int) -> LevelConfiguration:
	for config in level_configs:
		if config.id == id:
			return config
	return null
