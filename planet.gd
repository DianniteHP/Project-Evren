extends StaticBody2D

@export var planetSize :float = 1
@export var texture :Texture2D
@export var visuals :Sprite2D
@export var solidCollision :CollisionShape2D
@export var gravityCollision :CollisionShape2D

func _ready() -> void:
	visuals.scale = Vector2(planetSize, planetSize)
	solidCollision.scale = Vector2(planetSize, planetSize)
	gravityCollision.scale = 4* Vector2(planetSize, planetSize)
	visuals.texture = texture
