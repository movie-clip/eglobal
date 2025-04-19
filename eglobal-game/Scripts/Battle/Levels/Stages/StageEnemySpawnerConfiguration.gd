extends Resource
class_name StageEnemySpawnerConfiguration

@export var spawners: Array[EnemySpawnerConfiguration]


func get_wave(wave_index: int) -> EnemySpawnerConfiguration:
	return spawners[wave_index]
