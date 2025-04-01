extends CharacterBody2D
class_name EnemyController

@export var data: EnemyData
@export var targetPosition: Vector2

@onready var sprite: Sprite2D = $Panel/Sprite2D 
var lane_y: float = 0.0

func _ready() -> void:
	lane_y = global_position.y

	if data:
		sprite.texture = data.texture
	
func _physics_process(delta: float) -> void:

	var desired_x = targetPosition.x
	var dx = abs(desired_x - global_position.x)
	
	if dx > data.attack_range:
		var direction_x = (desired_x - global_position.x) / dx
		velocity = Vector2(direction_x, 0) * data.movement_speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		# TODO: Attack logic can be implemented here when within range.
