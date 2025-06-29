class_name EnemyAttack extends State

@export var enemy: CharacterBody2D

func enter():
	enemy.velocity = Vector2.ZERO
	print("Атакую игрока!")

func update(delta: float):
	if enemy.has_method("is_player_in_attack_range") and not enemy.is_player_in_attack_range():
		enemy.change_state(enemy.chase_state)

func physics_update(delta: float):
	enemy.velocity = Vector2.ZERO
