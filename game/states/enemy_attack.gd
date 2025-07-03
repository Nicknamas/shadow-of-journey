class_name EnemyAttack
extends State

@export var enemy: CharacterBody2D
@export var attack_radius: float = 20.0
@export var attack_cooldown: float = 1.0
@export var name_group_target: String = "Hero"

var aggro_target: Node2D
var attack_timer: float = 0.0

func enter():
	if enemy.has_meta("aggro_target"):
		aggro_target = enemy.get_meta("aggro_target")
	attack_timer = 0.0
	enemy.velocity = Vector2.ZERO

func update(delta: float):
	if not aggro_target or not is_instance_valid(aggro_target):
		emit_signal("transitioned", self, "EnemyIdle")
		return

	var dist = enemy.global_position.distance_to(aggro_target.global_position)
	if dist > attack_radius:
		emit_signal("transitioned", self, "EnemyChase")
		return

	attack_timer += delta
	if attack_timer >= attack_cooldown:
		perform_attack()
		attack_timer = 0.0

func physics_update(_delta):
	enemy.velocity = Vector2.ZERO

func perform_attack():
	if aggro_target.has_method("take_damage"):
		aggro_target.call("take_damage", enemy.damage)
