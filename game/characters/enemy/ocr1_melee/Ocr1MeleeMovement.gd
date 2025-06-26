extends MovementBase

@export var target: Node2D = null
var is_player_inside: bool = false

func _ready():
	$AggroArea.body_entered.connect(_on_body_entered)
	$AggroArea.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Hero":
		target = body
		is_player_inside = true

func _on_body_exited(body):
	if body == target:
		is_player_inside = false
		target = null

func _physics_process(delta: float) -> void:
	if is_player_inside and target and is_instance_valid(target):
		direction = (target.global_position - global_position).normalized()
	else:
		direction = Vector2.ZERO

	super._physics_process(delta)
