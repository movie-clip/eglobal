extends CharacterBody2D
class_name PlayerController

var targetPosition: Vector2
var isMoving: bool

func _physics_process(delta: float) -> void:
	if !isMoving:
		return
		
	var dx = targetPosition.x - global_position.x
	var movement_velocity = Vector2(0, 0)
	if abs(dx) > 5:
		movement_velocity.x = sign(dx) * 50
	else:
		movement_velocity.x = 0
		isMoving = false
	
	velocity = movement_velocity
	move_and_slide()
