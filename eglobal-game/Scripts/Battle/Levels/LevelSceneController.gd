extends Node2D
class_name LevelSceneController

@export var level_container: Node2D
@export var player_scene: PackedScene

var current_level_scene: LevelController
var current_level_config: LevelConfiguration
var current_stage_index: int
var player_controller: PlayerController

func _ready():
	SignalBus.stage_finished.connect(Callable(self, "on_stage_finished"))

func load_level(config: LevelConfiguration):
	if current_level_scene:
		current_level_scene.queue_free()
		current_level_scene = null
		current_level_config = null
	
	current_level_config = config
	current_level_scene = config.level_scene.instantiate()
	level_container.add_child(current_level_scene)

func load_stage(stageIndex: int):
	current_stage_index = stageIndex
	var stageConfig = current_level_config.stages[current_stage_index]
	current_level_scene.load_stage(stageConfig)

func start_level():
	if !current_level_scene:
		return
	
	current_level_scene.activate_stage()
	
	var command = MoveCommand.new()
	var context = CommandParam.new()
	context.params.append(player_controller)
	context.params.append(Vector2(300, 0))
	command.execute(context, self)

func create_player():
	player_controller = player_scene.instantiate()
	player_controller.global_position = current_level_scene.current_stage_scene.player_spawn_position
	self.add_child(player_controller)

func on_stage_finished():
	if is_last_stage():
		return
	remove_stage()
	load_stage(current_stage_index + 1)
	
	player_controller.isMoving = false
	player_controller.global_position = current_level_scene.current_stage_scene.player_spawn_position
	current_level_scene.activate_stage()
	
func is_last_stage() -> bool:
	return current_stage_index >= current_level_config.stages.size() - 1
	
func remove_stage():
	current_level_scene.remove_stage()
