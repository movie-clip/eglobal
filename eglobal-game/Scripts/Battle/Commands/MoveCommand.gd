extends Command
class_name MoveCommand

func execute(context: CommandParam, parent: Node2D):
	var movable = context.params[0]
	movable.targetPosition = context.params[1]
	movable.isMoving = true
