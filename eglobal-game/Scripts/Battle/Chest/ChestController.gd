extends Node2D
class_name ChestController

@export var data: ChestConfig

func _ready() -> void:
	$Detector.connect("body_entered", Callable(self, "_on_Detector_body_entered"))

func _on_Detector_body_entered(body: Node):
	if body is PlayerController:
		SignalBus.stage_finished.emit()
		$Detector.monitoring = false
