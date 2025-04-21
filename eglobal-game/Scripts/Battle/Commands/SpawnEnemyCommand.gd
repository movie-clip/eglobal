extends Command
class_name SpawnEnemyCommand

var result: Object

func execute(context: CommandParam, parent: Node2D):
	var config = context.params[0] as EnemyConfig
	var spawn_position = context.params[1]
	
	result = config.get_scene().instantiate()
	result.data = config
	result.global_position = spawn_position
	parent.add_child(result)
