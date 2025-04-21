extends Node2D
class_name LevelSceneController

@export var level_container: Node2D
@export var player_scene: PackedScene

var current_level_scene: LevelController
var current_level_config: LevelConfiguration
var player_controller: PlayerController

func _ready():
	pass

func load_level(config: LevelConfiguration):
	if current_level_scene:
		current_level_scene.queue_free()
		current_level_scene = null
		current_level_config = null
	
	current_level_config = config
	current_level_scene = config.level_scene.instantiate()
	level_container.add_child(current_level_scene)

func load_stage(config: StageConfiguration):
	current_level_scene.load_stage(config)

func start_level():
	if !current_level_scene:
		return
	current_level_scene.activate_enemy_spawner()
	
	var command = MoveCommand.new()
	var context = CommandParam.new()
	context.params.append(player_controller)
	context.params.append(Vector2(300, 0))
	command.execute(context, self)

func next_stage():
	current_level_scene.load_stage(current_level_config.stages[0])

func create_player():
	player_controller = player_scene.instantiate()
	player_controller.global_position = current_level_scene.current_stage_scene.player_spawn_position
	self.add_child(player_controller)
