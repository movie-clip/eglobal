extends Node

var MaxPlayerHp: int = 3000
var CurrentPlayerHp: int = 3000
var CurrentPlayerLvl: int = 1
var CurrentPlayerExp: int = 0
var ExpForNextLvl: int = 100

var levels = [0, 100, 200, 300, 400]

func OnBattlaButtonClickEvent() -> void:
	Events.OnBattlaButtonClick.emit()

func OnCompliteLevelStageEvent() -> void:
	Events.OnCompliteLevelStage.emit()

func OnPlayerHpChangeEvent(Value: int):
	CurrentPlayerHp += Value
	Events.OnPlayerHpChanged.emit(Value)

func OnPlayerExpChangedEvent(Value: int):
	CurrentPlayerExp += Value
	Events.OnPlayerExpChanged.emit(Value)
	var LevelUp: int = (CurrentPlayerExp + Value) / ExpForNextLvl
	if (LevelUp >= 1):
		CurrentPlayerExp = 0
		CurrentPlayerLvl += LevelUp
		OnPlayerLvlChangedEvent(LevelUp)

func OnPlayerLvlChangedEvent(Value: int):
	CurrentPlayerLvl += Value
	Events.OnPlayerLvlChanged.emit(Value)

func check_level_up():
	while (CurrentPlayerLvl < levels.size() and CurrentPlayerExp >= levels[CurrentPlayerLvl]):
		CurrentPlayerLvl += 1
		print("Повышен уровень! Новый уровень: " + str(CurrentPlayerLvl))
		CurrentPlayerExp -= levels[CurrentPlayerLvl - 1]

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
