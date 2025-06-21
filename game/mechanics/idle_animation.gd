class_name IdleAnimation extends Node

enum LAST_DIRECTIONS { LEFT = -1, RIGHT = 1, DOWN = -2, UP = 2 }

var _animated_sprite: AnimatedSprite2D

const ANIMATION_NAMES = {
	LAST_DIRECTIONS.RIGHT: "idle_side",
	LAST_DIRECTIONS.LEFT: "idle_side",
	LAST_DIRECTIONS.UP: "idle_up",
	LAST_DIRECTIONS.DOWN: "idle_down",
}

func _init(animated_sprite: AnimatedSprite2D):
	_animated_sprite = animated_sprite


func play_animation_idle(last_direction: LAST_DIRECTIONS) -> void:
		var animation_name = ANIMATION_NAMES[last_direction]
		if animation_name == "idle_side":
			_animated_sprite.flip_h = last_direction == LAST_DIRECTIONS.RIGHT
		_animated_sprite.play(animation_name)
	
