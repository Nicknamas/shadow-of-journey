extends MovementBase

@export var target: Node2D = null
@export var aggro_radius: float = 100.0
@export var attack_radius: float = 40.0

func _ready():
	if not target:
		target = get_tree().get_current_scene().find_child("Hero", true, false)

func _physics_process(delta: float) -> void:
	if target and is_instance_valid(target):
		var distance_to_player = global_position.distance_to(target.global_position)

		if distance_to_player <= aggro_radius and distance_to_player > attack_radius:
			direction = (target.global_position - global_position).normalized()
		else:
			direction = Vector2.ZERO

		if distance_to_player <= attack_radius:
			print("Атака игрока!")
	else:
		direction = Vector2.ZERO

	super._physics_process(delta)
