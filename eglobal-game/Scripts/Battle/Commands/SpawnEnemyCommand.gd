extends Command
class_name SpawnEnemyCommand

class SpawnData:
	var entityID: int
	var position: Vector2
	
	func init(id:int, pos:Vector2):
		entityID = id
		position = pos
		
func execute(data: Object):
	if data is SpawnData:
		pass
	pass
