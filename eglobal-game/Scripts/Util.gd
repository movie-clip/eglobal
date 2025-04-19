extends Node

enum RESOURCE_TYPE {COIN}

enum GUI_SCENES {META, BATTLE}
enum WORLD_SCENES {META, BATTLE}

var MetaGUIScenePath: String = "res://Scenes/MetaGUI.tscn"
#var BattleGUIScenePath: String = "res://Scenes/Battle/UI/BattleUiRoot.tscn"
var BattleGUIScenePath: String = "res://Scenes/Battle/UI/battle_temp_ui.tscn"

var BattleScene: String = "res://Scenes/Battle/battle_level.tscn"
var MetaScene: String = "res://Scenes/Battle/battle_level.tscn"

var BattleUIVictory: String = "res://Scenes/Battle/UI/BattleVictoryRoot.tscn"
