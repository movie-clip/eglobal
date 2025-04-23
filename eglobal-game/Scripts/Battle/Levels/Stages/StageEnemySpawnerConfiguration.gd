extends Resource
class_name StageEnemySpawnerConfiguration

@export var spawners: Array[EntitySpawnerConfig]


func get_wave(wave_index: int) -> EntitySpawnerConfig:
	return spawners[wave_index]
