class_name Hero extends MovementBase

@onready var animation_player: AnimationPlayer = $AnimationPlayer

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
