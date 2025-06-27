class_name MovementBase extends CharacterBody2D

@export var speed: float = 100.0
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta):
	self.velocity = self.direction.normalized() * self.speed
	move_and_slide()


var is_player_in_attack_range: bool = false

func _on_attack_radius_body_entered(body: Node) -> void:
	if body.name == "Hero":
		self.is_player_in_attack_range = true
		self._on_player_entered_attack_range(body)

func _on_attack_radius_body_exited(body: Node) -> void:
	if body.name == "Hero":
		self.is_player_in_attack_range = false
		self._on_player_exited_attack_range(body)

func _on_player_entered_attack_range(body: Node) -> void:
	pass

func _on_player_exited_attack_range(body: Node) -> void:
	pass
