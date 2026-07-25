extends Area2D

@export var mass :int
@export var collision_scale :float = 1

var is_orbiting :bool = false

func _ready() -> void:
	self.scale = Vector2(collision_scale, collision_scale)



#func _on_body_entered(body: CharacterBody2D) -> void:
	#is_orbiting = true
	#orbiting(body)
#
#func orbiting(body :CharacterBody2D):
	#while is_orbiting == true:
		#body.position += Vector2(5,0)
		#await get_tree().create_timer(0.05).timeout
		#print("something")
#
#func _on_body_exited(body: Node2D) -> void:
	#is_orbiting = false
