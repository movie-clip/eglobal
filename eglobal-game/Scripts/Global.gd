extends Node

var game_controller: GameController
var debug: DebugController

var playerService: PlayerService
var inventoryService: InventoryService
var inventoryDataProvider: InventoryDataProvider

func _ready() -> void:
	playerService = PlayerService.new()
	
	inventoryService = InventoryService.new()
	inventoryService.init()

	inventoryDataProvider = InventoryDataProvider.new()
	inventoryDataProvider.init()

func on_battla_button_clicked() -> void:
	SignalBus.battle_button_clicked.emit()

func on_level_stage_complited() -> void:
	SignalBus.level_stage_complited.emit()
