class_name WalkAnimation extends Node2D

var _animated_sprite: AnimatedSprite2D
enum DIRECTION { UP = 2, RIGHT = 1, LEFT = -1, DOWN = -2 }

var last_direction: DIRECTION = DIRECTION.RIGHT

const ANIMATION_DIRECTIONS = {
	Vector2i.UP: "UP",
	Vector2i.RIGHT: "RIGHT",
	Vector2i.LEFT: "LEFT",
	Vector2i.DOWN: "DOWN"
}

const ANIMATION_NAMES = {
	ANIMATION_DIRECTIONS[Vector2i.UP]: "walk_up",
	ANIMATION_DIRECTIONS[Vector2i.RIGHT]: "walk_side",
	ANIMATION_DIRECTIONS[Vector2i.LEFT]: "walk_side",
	ANIMATION_DIRECTIONS[Vector2i.DOWN]: "walk_down"
}


func play_animation_walk(vector_movement: Vector2) -> void:
	var animation_direction = get_animation_name_by_vector(vector_movement)
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


func get_animation_name_by_vector(vector_movement: Vector2) -> String:
	const CORRECT_LENGTH = 1
	const INITIAL_VALUE_VECTOR = 0
	if vector_movement.length_squared() != CORRECT_LENGTH:
		vector_movement.x = INITIAL_VALUE_VECTOR
		vector_movement.y = round(vector_movement.y)
	return ANIMATION_DIRECTIONS.get(vector_movement as Vector2i)


func _init(animated_sprite: AnimatedSprite2D):
	_animated_sprite = animated_sprite
