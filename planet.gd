extends StaticBody2D

@export var planet_size :float = 1
@export var texture :Texture2D
@export var visuals :Sprite2D
@export var solid_collision :CollisionShape2D
@export var gravity_collision :CollisionShape2D

func _ready() -> void:
	visuals.scale = Vector2(planet_size, planet_size)
	solid_collision.scale = Vector2(planet_size, planet_size)
	gravity_collision.scale = 4* Vector2(planet_size, planet_size)
	visuals.texture = texture
