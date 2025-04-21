extends Resource
class_name StageConfiguration

@export var stage_id: int
@export var stage_scene: PackedScene

@export var spawners: Array[StageEnemySpawnerConfiguration]
@export var stage_rules: Array[LevelRuleConfig]
