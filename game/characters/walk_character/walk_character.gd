extends CharacterBody2D

@export var speed = 400
@onready var _animated_sprite = $AnimatedSprite2D

var last_direction: String = "right"

func playAnimationWalkWithVerticalDirection(direction: String) -> void:
	if direction == "up":
		_animated_sprite.play("walk_up")
		last_direction = "up"
	else:
		_animated_sprite.play("walk_down")
		last_direction = "down"

func playAnimationWalkWithHorizontalDirection(direction: String) -> void:
	if direction == "right":
		_animated_sprite.flip_h = true
		last_direction = "right"
	else:
		_animated_sprite.flip_h = false
		last_direction = "left"
	_animated_sprite.play("walk_side")

func playAnimationWalk(vector_movement: Vector2) -> void:
	if vector_movement.x > 0:
		playAnimationWalkWithHorizontalDirection("right")
	elif vector_movement.x < 0:
		playAnimationWalkWithHorizontalDirection("left")
	elif vector_movement.y < 0:
		playAnimationWalkWithVerticalDirection("up")
	else:
		playAnimationWalkWithVerticalDirection("down")


func playAnimationIdle() -> void:
	if last_direction == "right" or last_direction == "left":
		_animated_sprite.flip_h = last_direction == "right"
		_animated_sprite.play("idle_side")
	elif last_direction == "up":
		_animated_sprite.play("idle_up")
	else:
		_animated_sprite.play("idle_down")


func playAnimation(animation_type: String, vector_movement: Vector2) -> void:
	if animation_type == "walk":
		playAnimationWalk(vector_movement)
	if animation_type == "idle":
		playAnimationIdle()


func processInput(vector_movement: Vector2) -> void:
	if vector_movement.x != 0 or vector_movement.y != 0:
		playAnimation("walk", vector_movement)
	else:
		playAnimation("idle", vector_movement)


func get_input() -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	processInput(input_direction)


func _physics_process(delta) -> void:
	get_input()
	move_and_slide()
