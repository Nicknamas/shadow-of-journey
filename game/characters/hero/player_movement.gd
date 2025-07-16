class_name Hero extends MovementBase

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(delta):
	self.direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	super._physics_process(delta)
