class_name EnemyAttack
extends State

@export var enemy: CharacterBody2D
@export var attack_radius: float = 20.0
@export var attack_cooldown: float = 1.0
@export var attack_duration: float = 0.4
@export var name_group_target: String = "Hero"

var aggro_target: Node2D
var attack_timer: float = 0.0
var attack_in_progress: bool = false
var attack_elapsed: float = 0.0

func enter():
	if enemy.has_meta("aggro_target"):
		aggro_target = enemy.get_meta("aggro_target")
	else:
		aggro_target = null

	enemy.velocity = Vector2.ZERO
	enemy.attacking = false
	attack_timer = attack_cooldown  # чтобы сразу ударить
	attack_in_progress = false
	attack_elapsed = 0.0

func end_attack_state(next_state: String):
	enemy.attacking = false
	attack_in_progress = false
	attack_elapsed = 0.0
	attack_timer = 0.0
	emit_signal("transitioned", self, next_state)

func exit():
	enemy.attacking = false
	attack_in_progress = false
	attack_elapsed = 0.0
	attack_timer = 0.0

func update(delta: float):
	# Проверка цели
	if not aggro_target or not is_instance_valid(aggro_target) or aggro_target.is_queued_for_deletion():
		enemy.attacking = false
		end_attack_state("EnemyIdle")
		return

	var dist = enemy.global_position.distance_to(aggro_target.global_position)
	if dist > attack_radius:
		end_attack_state("EnemyChase")
		return

	if attack_in_progress:
		attack_elapsed += delta
		if attack_elapsed >= attack_duration:
			enemy.attacking = false
			attack_in_progress = false
		return

	# Атака готова
	attack_timer += delta
	if attack_timer >= attack_cooldown:
		start_attack()

func physics_update(_delta):
	enemy.velocity = Vector2.ZERO

func start_attack():
	enemy.attacking = true
	attack_timer = 0.0
	attack_elapsed = 0.0
	attack_in_progress = true

	# Проверка радиуса перед нанесением урона
	if is_instance_valid(aggro_target) and not aggro_target.is_queued_for_deletion():
		if enemy.global_position.distance_to(aggro_target.global_position) <= attack_radius:
			if aggro_target.has_method("take_damage"):
				aggro_target.call("take_damage", enemy.damage)
