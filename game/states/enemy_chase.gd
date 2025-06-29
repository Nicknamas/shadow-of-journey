class_name EnemyChase
extends State

@export var enemy: CharacterBody2D
@export var move_speed: float = 120.0
@export var aggro_area: Area2D

var target: Node2D = null

func enter():
	for body in aggro_area.get_overlapping_bodies():
		if body.name == "Hero":
			target = body
			break

func update(delta: float):
	if not target or not aggro_area.get_overlapping_bodies().has(target):
		emit_signal("transitioned", self, "EnemyIdle")

func physics_update(delta: float):
	if enemy and target:
		var direction = (target.global_position - enemy.global_position).normalized()
		enemy.velocity = direction * move_speed
