class_name MovementBase extends CharacterBody2D

@export var speed: float = 100.0
var direction: Vector2 = Vector2.ZERO
	
func _physics_process(delta):
	self.velocity = self.direction.normalized() * self.speed
	move_and_slide()
	
