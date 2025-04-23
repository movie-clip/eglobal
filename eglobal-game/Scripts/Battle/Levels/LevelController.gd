extends Node2D
class_name LevelController

@export var stage_container: Node2D

var current_stage_scene: StageController
var current_stage_config: StageConfiguration

var current_spawner: StageEnemySpawnerConfiguration
var current_wave_index: int = 0

func _ready() -> void:
	SignalBus.wave_finished.connect(Callable(self, "on_wave_finished"))
	
func load_stage(config: StageConfiguration):
	if current_stage_scene:
		current_stage_scene.queue_free()
		current_stage_scene = null
		current_stage_config = null
	
	current_stage_config = config
	current_stage_scene = config.stage_scene.instantiate()
	stage_container.add_child(current_stage_scene)
	current_wave_index = 0

func activate_stage():
	current_spawner = current_stage_config.spawners[0]
	activate_wave(current_wave_index)
	

func activate_wave(waveIndex: int):
	var wave = current_spawner.get_wave(waveIndex)
	var spawn_position = current_stage_scene.get_spawn_position(wave.laneIndex)
	
	var enemies: Array[EnemyController] = []
	
	for enemy in wave.entities:
		var command = SpawnEntityCommand.new()
		var context = CommandParam.new()
		context.params.append(enemy)
		context.params.append(spawn_position)
		command.execute(context, current_stage_scene)
		enemies.append(command.result)
		
	for enemy in enemies:
		var command = MoveCommand.new()
		var context = CommandParam.new()
		context.params.append(enemy)
		context.params.append(current_stage_scene.player_spawn_position)
		command.execute(context, self)

func on_wave_finished():
	if is_last_wave():
		return
	current_wave_index = current_wave_index + 1
	activate_wave(current_wave_index)

func is_last_wave() -> bool:
	return current_wave_index < current_spawner.spawners.size()

func evaluate_rules() -> bool:
	for rule in current_stage_config.stage_rules:
		if !rule.check_success_criteria():
			return false
	return true

func remove_stage():
	current_stage_scene.queue_free()
	current_stage_scene = null
	current_stage_config = null
