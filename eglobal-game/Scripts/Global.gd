extends Node

var game_controller: GameController
var debug: DebugController

var playerService: PlayerService

func _ready() -> void:
	playerService = PlayerService.new()

func on_battla_button_clicked() -> void:
	SignalBus.battle_button_clicked.emit()

func on_level_stage_complited() -> void:
	SignalBus.level_stage_complited.emit()
	