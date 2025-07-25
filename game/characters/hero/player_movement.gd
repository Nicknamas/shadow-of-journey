class_name Hero extends MovementBase

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var max_health: int = 100
@export var current_health: int = 100
@export var damage: int = 10
@export var attack_radius := 40.0
@export var attack_angle_deg := 60.0

var attacking := false
@export var attack_duration := 0.5


func _ready():
	NavigationManager.on_trigger_player_spawn.connect(on_spawn)


func take_damage(amount: int):
	current_health -= amount
	print("герой получает урон. его хп - ", current_health)
	if current_health <= 0:
		die()


func die():
	pass
	


func _physics_process(delta):
	self.direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	if Input.is_action_just_pressed("attack") and not attacking:
		start_attack()
	
	super._physics_process(delta) 


func on_spawn(position : Vector2, direction : String) -> void:
	self.global_position = position
	self.animation_player.play("walk_" + direction)
	self.animation_player.stop()


func start_attack():
	attacking = true
	print("Атака начата")
	
	await get_tree().create_timer(attack_duration).timeout
	perform_attack_check()

	attacking = false
	print("Атака завершена")


func perform_attack_check():
	var enemies = get_tree().get_nodes_in_group("Enemies")

	for enemy in enemies:
		if not enemy or not enemy.has_method("take_damage"):
			continue

		var to_enemy = enemy.global_position - global_position
		var distance = to_enemy.length()
		if distance > attack_radius:
			continue

		var angle_to_enemy = direction.angle_to(to_enemy.normalized())
		if abs(rad_to_deg(angle_to_enemy)) > attack_angle_deg / 2.0:
			continue

		enemy.take_damage(damage)
		print("урон нанесен")
