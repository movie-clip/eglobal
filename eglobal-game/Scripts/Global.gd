extends Node

var game_controller: GameController
var debug: DebugController

var player: PlayerModel

func _ready() -> void:
	player = PlayerModel.new()
