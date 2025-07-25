extends CharacterBody2D

@export var max_health: int = 100
@export var current_health: int = 100
@export var damage: int = 10

var attacking := false


func take_damage(amount: int):
	current_health -= amount
	print("орк получает урон. его хп - ", current_health)
	if current_health <= 0:
		die()


func die():
	queue_free()


func _physics_process(_delta):
	move_and_slide()


func end_attack():
	attacking = false
