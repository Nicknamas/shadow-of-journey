class_name EnemyIdle
extends State

@export var enemy : CharacterBody2D
@export var move_speed : float = 80.0
@export var aggro_area : Area2D

var move_direction : Vector2
var wander_time : float

func randomize_wander() -> void:
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)

func enter():
	randomize_wander()

func update(delta: float):
	for body in aggro_area.get_overlapping_bodies():
		if body.name == "Hero":
			emit_signal("transitioned", self, "EnemyChase")
			return

	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func physics_update(delta: float):
	if enemy:
		enemy.velocity = move_direction * move_speed
