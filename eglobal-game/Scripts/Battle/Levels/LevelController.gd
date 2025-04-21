extends Node2D
class_name LevelController

@export var stage_container: Node2D

var current_stage_scene: StageController
var current_stage_config: StageConfiguration

func load_stage(config: StageConfiguration):
	if current_stage_scene:
		current_stage_scene.queue_free()
		current_stage_scene = null
		current_stage_config = null
	
	current_stage_config = config
	current_stage_scene = config.stage_scene.instantiate()
	stage_container.add_child(current_stage_scene)

func activate_enemy_spawner():
	if !current_stage_scene:
		return
	
	var spawner = current_stage_config.spawners[0]
	var wave = spawner.get_wave(0)
	var spawn_position = current_stage_scene.get_spawn_position(wave.laneIndex)
	
	var enemies: Array[EnemyController] = []
	
	for enemy in wave.enemies:
		var command = SpawnEnemyCommand.new()
		var context = CommandParam.new()
		context.params.append(enemy)
		context.params.append(spawn_position)
		command.execute(context, self)
		enemies.append(command.result)
		
	for enemy in enemies:
		var command = MoveCommand.new()
		var context = CommandParam.new()
		context.params.append(enemy)
		context.params.append(current_stage_scene.player_spawn_position)
		command.execute(context, self)
