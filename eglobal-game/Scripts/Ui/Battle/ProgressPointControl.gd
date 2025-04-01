extends Control
class_name ProgressPointControl
@export var data: ProgressPointData

@onready var FlagTextureRect: TextureRect = $FlagTextureRect
@onready var RoundTextureRect: TextureRect = $RoundTextureRect
@onready var PointTextureRect: TextureRect = $RoundTextureRect/PointTextureRect
@onready var ProgressPointLevel: RichTextLabel = $PointRichTextLabel

var TargetPosition: Vector2

func _ready() -> void:
	if data:
		FlagTextureRect.texture = data.FlagTextureRect
		RoundTextureRect.texture = data.RoundTextureRect
		PointTextureRect.texture = data.PointTextureRect
		ProgressPointLevel.text = data.ProgressPointLevel

func _process(delta: float) -> void:
	pass

func change_position_on_slider(Position: Vector2) -> void:
	self.global_position = Position
