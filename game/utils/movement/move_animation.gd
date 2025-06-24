class_name MoveAnimation extends Node2D

@export var _animated_sprite: AnimatedSprite2D
@export var debug: bool = false

enum ANIMATION_STATES { WALK, IDLE }
enum LAST_DIRECTIONS { LEFT, RIGHT, DOWN, UP }

var _walk_controller: WalkAnimation
var _idle_controller: IdleAnimation

var last_direction = LAST_DIRECTIONS.RIGHT

func play_animation(animation_type: ANIMATION_STATES, vector_movement: Vector2) -> void:
	if animation_type == ANIMATION_STATES.WALK:
		_walk_controller.play_animation_walk(vector_movement)
		last_direction = _walk_controller.get_last_direction()
	if animation_type == ANIMATION_STATES.IDLE:
		_idle_controller.play_animation_idle(last_direction)


func _handle_input() -> void:
	var vector_movement = Input.get_vector("left", "right", "up", "down")
	_logging_vector(vector_movement)
	if vector_movement.x != 0 or vector_movement.y != 0:
		play_animation(ANIMATION_STATES.WALK, vector_movement)
	else:
		play_animation(ANIMATION_STATES.IDLE, vector_movement)


func _logging_vector(logging_expression: Variant) -> void:
	if debug:
		print(logging_expression)


func _ready():
	_walk_controller = WalkAnimation.new(_animated_sprite)
	_idle_controller = IdleAnimation.new(_animated_sprite)


func _physics_process(_delta) -> void:
	_handle_input()
