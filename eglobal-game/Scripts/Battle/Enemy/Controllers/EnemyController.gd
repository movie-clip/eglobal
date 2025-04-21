extends CharacterBody2D
class_name EnemyController

@export var data: EnemyConfig
@export var targetPosition: Vector2

@onready var sprite: Sprite2D = $Panel/Sprite2D 
var lane_y: float = 0.0
var isMoving: bool = false

func _ready() -> void:
	lane_y = global_position.y

	if data:
		sprite.texture = data.texture

func _physics_process(delta: float) -> void:
	if !isMoving:
		return
		
	var dx = targetPosition.x - global_position.x
	var movement_velocity = Vector2(0, 0)
	if abs(dx) > data.attack_range:
		movement_velocity.x = sign(dx) * data.movement_speed
	else:
		movement_velocity.x = 0
		isMoving = false
	
	velocity = movement_velocity
	move_and_slide()
