extends RigidBody2D

@export var rotationSpeed :float = 2.0
@export var thrustPower :float = 300.0


func _physics_process(delta: float) -> void:
	var rotateDirection = Input.get_axis("Rotate left", "Rotate right")
	angular_velocity = rotateDirection * rotationSpeed
	
	if Input.is_action_pressed("Accelerate"):
		var forwardDirection = Vector2.UP.rotated(rotation)
		apply_central_force(forwardDirection * thrustPower)
		$AnimatedSprite2D.show()
		$AnimatedSprite2D.play("engineEffect")
	else:
		$AnimatedSprite2D.hide()
		$AnimatedSprite2D.stop()
	Global.speed = linear_velocity.length()
	
