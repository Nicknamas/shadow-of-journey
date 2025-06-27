class_name EnemyIdle extends State

@export var enemy : CharacterBody2D
@export var move_speed : float = 80.0


var move_direction : Vector2
var wander_time : float

func randomize_wander() -> void:
	self.move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	self.wander_time = randf_range(1, 3)


func enter():
	self.randomize_wander()


func update(delta: float):
	if self.wander_time > 0:
		self.wander_time -= delta
	else:
		self.randomize_wander()


func physics_update(delta: float):
	if self.enemy:
		self.enemy.velocity = self.move_direction * self.move_speed
		print(self.enemy.velocity)
