extends Node

var MaxPlayerHp: int = 3000
var CurrentPlayerHp: int = 3000
var CurrentPlayerLvl: int = 1
var CurrentPlayerExp: int = 0
var ExpForNextLvl: int = 100
var levels = [0, 100, 200, 300, 400, 600, 800, 1000, 10000]

func OnBattlaButtonClickEvent() -> void:
	Events.OnBattlaButtonClick.emit()

func OnCompliteLevelStageEvent() -> void:
	Events.OnCompliteLevelStage.emit()

func OnPlayerHpChangeEvent(Value: int):
	CurrentPlayerHp += Value
	Events.OnPlayerHpChanged.emit(Value)

func OnPlayerExpChangedEvent(Value: int):
	CurrentPlayerExp += Value
	while (CurrentPlayerExp >= ExpForNextLvl):
		CurrentPlayerExp -= ExpForNextLvl
		CurrentPlayerLvl += 1
		if (levels.size() > CurrentPlayerLvl):
			ExpForNextLvl = levels[CurrentPlayerLvl]
	OnPlayerExpForNextLvlChangedEvent(ExpForNextLvl)
	OnPlayerLvlChangedEvent(CurrentPlayerLvl)
	Events.OnPlayerExpChanged.emit(CurrentPlayerExp)

func OnPlayerLvlChangedEvent(Value: int):
	Events.OnPlayerLvlChanged.emit(Value)

func OnPlayerExpForNextLvlChangedEvent(Value: int):
	Events.OnPlayerExpForNextLvlChanged.emit(Value)

func GetMaxPlayerHp():
	return MaxPlayerHp

func GetCurrentPlayerHp():
	return CurrentPlayerHp

func GetCurrentPlayerLvl():
	return CurrentPlayerLvl

func GetCurrentPlayerExp():
	return CurrentPlayerExp

func GetExpForNextLvl():
	return ExpForNextLvl
