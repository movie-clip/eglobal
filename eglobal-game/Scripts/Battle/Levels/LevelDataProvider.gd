class_name LevelDataProvider

var table: LevelResourceTable

func init():
	table = load("res://Authoring/Levels/LevelResourceTable.tres")

func get_level_config(id: int) -> LevelConfiguration:
	return table.get_config(id)
