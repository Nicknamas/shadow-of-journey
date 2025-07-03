class_name EnemyChase
extends State

@export var enemy: CharacterBody2D
@export var move_speed: float = 100.0
@export var aggro_radius: float = 100.0
@export var attack_radius: float = 20.0
@export var name_group_target: String = "Hero"

var aggro_target: Node2D = null

func enter():
	if enemy.has_meta("aggro_target"):
		aggro_target = enemy.get_meta("aggro_target")

func update(_delta: float):
	if not aggro_target or not is_instance_valid(aggro_target):
		var new_target = find_closest_enemy_within_radius()
		if new_target:
			aggro_target = new_target
		else:
			emit_signal("transitioned", self, "EnemyIdle")
			return
	
	var dist_to_current = enemy.global_position.distance_to(aggro_target.global_position)
	
	if dist_to_current <= attack_radius and is_target_in_front():
		enemy.set_meta("aggro_target", aggro_target)
		emit_signal("transitioned", self, "EnemyAttack")
		return
	
	var closer = find_closer_enemy_than(dist_to_current)
	if closer:
		aggro_target = closer


func physics_update(_delta: float):
	if aggro_target:
		var dir = (aggro_target.global_position - enemy.global_position).normalized()
		enemy.velocity = dir * move_speed


func find_closest_enemy_within_radius() -> Node2D:
	var closest = null
	var min_dist = aggro_radius
	for node in get_tree().get_nodes_in_group(name_group_target):
		if not node["global_position"]:
			continue
		var dist = enemy.global_position.distance_to(node.global_position)
		if dist <= min_dist and (closest == null or dist < enemy.global_position.distance_to(closest.global_position)):
			closest = node
	return closest


func find_closer_enemy_than(distance: float) -> Node2D:
	var closer = null
	for node in get_tree().get_nodes_in_group(name_group_target):
		if not node["global_position"]:
			continue
		var dist = enemy.global_position.distance_to(node.global_position)
		if dist <= aggro_radius and dist < distance:
			distance = dist
			closer = node
	return closer


func is_target_in_front() -> bool:
	if enemy.velocity.length() == 0:
		return true  # Если враг стоит — считаем, что цель перед ним
	var dir_to_target = (aggro_target.global_position - enemy.global_position).normalized()
	var forward = enemy.velocity.normalized()
	return dir_to_target.dot(forward) > 0.5
