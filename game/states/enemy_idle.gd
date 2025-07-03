class_name EnemyIdle
extends State

@export var enemy : CharacterBody2D
@export var move_speed : float = 80.0
@export var aggro_radius : float = 100.0
@export var name_group_target: String = "Hero"

var move_direction : Vector2
var wander_time : float

func randomize_wander() -> void:
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)

func enter():
	randomize_wander()

func update(delta: float):
	var target = find_closest_enemy_in_aggro_range()
	if target:
		emit_signal("transitioned", self, "EnemyChase")
		return

	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func physics_update(delta: float):
	if enemy:
		enemy.velocity = move_direction * move_speed

func find_closest_enemy_in_aggro_range() -> Node2D:
	var closest = null

	for node in get_tree().get_nodes_in_group(name_group_target):
		if not node["global_position"]:
			continue
		var dist = enemy.global_position.distance_to(node.global_position)
		if dist <= aggro_radius and (closest == null or dist < enemy.global_position.distance_to(closest.global_position)):
			closest = node
	return closest
