extends MovementBase

@export var target : Node2D = null
@export var aggro_radius : float = 100.0
@export var attack_radius : float = 20.0
@export var debug : bool = false

func _ready():
	if not self.target:
		self.target = get_tree().get_current_scene().find_child("Hero", true, false)


func _physics_process(delta : float) -> void:
	if self.target and is_instance_valid(target):
		var distance_to_player = global_position.distance_to(self.target.global_position)

		if distance_to_player <= self.aggro_radius and distance_to_player > self.attack_radius:
			self.direction = (self.target.global_position - global_position).normalized()
		else:
			self.direction = Vector2.ZERO

		if distance_to_player <= attack_radius:
			if debug:
				print("Атака игрока!")
	else:
		self.direction = Vector2.ZERO

	super._physics_process(delta)
