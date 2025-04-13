extends Node

var game_controller: GameController
var debug: DebugController

var playerService: PlayerService
var inventoryService: InventoryService
var inventoryDataProvider: InventoryDataProvider

var levelDataProvider: LevelDataProvider

func _ready() -> void:
	playerService = PlayerService.new()
	
	inventoryService = InventoryService.new()
	inventoryService.init()

	inventoryDataProvider = InventoryDataProvider.new()
	inventoryDataProvider.init()
	
	levelDataProvider = LevelDataProvider.new()
	levelDataProvider.init() 

func on_battla_button_clicked() -> void:
	SignalBus.battle_button_clicked.emit()

func on_level_stage_complited() -> void:
	SignalBus.level_stage_complited.emit()
