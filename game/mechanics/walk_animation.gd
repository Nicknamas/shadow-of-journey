class_name WalkAnimation extends Node2D

var _animated_sprite: AnimatedSprite2D
enum DIRECTION { UP = 2, RIGHT = 1, LEFT = -1, DOWN = -2 }

var last_direction: DIRECTION = DIRECTION.RIGHT

const ANIMATION_DIRECTIONS = {
	2: "UP",
	1: "RIGHT",
	-1: "LEFT",
	-2: "DOWN"
}

const ANIMATION_NAMES = {
	ANIMATION_DIRECTIONS[DIRECTION.UP]: "walk_up",
	ANIMATION_DIRECTIONS[DIRECTION.RIGHT]: "walk_side",
	ANIMATION_DIRECTIONS[DIRECTION.LEFT]: "walk_side",
	ANIMATION_DIRECTIONS[DIRECTION.DOWN]: "walk_down"
}


func play_animation_walk(vector_movement: Vector2) -> void:
	var animation_direction = _get_animation_name_by_vector(vector_movement)
	last_direction = DIRECTION[animation_direction]
	if animation_direction == "RIGHT":
		_animated_sprite.flip_h = true
	elif animation_direction == "LEFT":
		_animated_sprite.flip_h = false

	var animation_name = ANIMATION_NAMES[animation_direction]
	_animated_sprite.play(animation_name)


func get_last_direction() -> DIRECTION:
	return last_direction


func _is_right_side_walk(vector_movement: Vector2) -> bool:
	return vector_movement.x > 0


func _get_animation_name_by_vector(vector_movement: Vector2) -> String:
	var x = vector_movement.x
	var doubled_y = vector_movement.y * 2
	var rounded_sum = int(round(x + doubled_y))
	return ANIMATION_DIRECTIONS.get(rounded_sum)


func _init(animated_sprite: AnimatedSprite2D):
	_animated_sprite = animated_sprite
