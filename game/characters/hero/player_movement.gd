class_name Hero extends MovementBase

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var max_health: int = 100
@export var current_health: int = 100
@export var damage: int = 10


func take_damage(amount: int):
	current_health -= amount
	print("герой получает урон. его хп -", current_health)
	if current_health <= 0:
		die()


func die():
	queue_free()
	
	
func _ready():
	NavigationManager.on_trigger_player_spawn.connect(on_spawn)


func _physics_process(delta):
	self.direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	super._physics_process(delta)


func on_spawn(position : Vector2, direction : String) -> void:
	self.global_position = position
	self.animation_player.play("walk_" + direction)
	self.animation_player.stop()
