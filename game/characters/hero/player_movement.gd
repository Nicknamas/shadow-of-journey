class_name Hero extends MovementBase

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var max_health: int = 100
@export var current_health: int = 100
@export var damage: int = 10

var attacking := false
@export var attack_duration := 0.5


func take_damage(amount: int):
	current_health -= amount
	print("герой получает урон. его хп -", current_health)
	if current_health <= 0:
		die()


func die():
	queue_free()
	


func _physics_process(delta):
	self.direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	if Input.is_action_just_pressed("attack") and not attacking:
		start_attack()
	
	super._physics_process(delta) 




func start_attack():
	attacking = true
	print("Атака начата")
	
	await get_tree().create_timer(attack_duration).timeout

	attacking = false
	print("Атака завершена")
