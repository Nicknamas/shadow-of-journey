class_name AnimationMovement extends Node2D

@export var animation_tree : AnimationTree
@export var entity : CharacterBody2D

var last_facing_direction := Vector2(0, -1)


func _physics_process(delta: float) -> void:
	var idle : bool = not entity.velocity

	if not idle:
		self.last_facing_direction = entity.velocity.normalized()

	self.animation_tree.set("parameters/conditions/idle", idle)
	self.animation_tree.set("parameters/conditions/run", not idle)

	self.animation_tree.set("parameters/Idle/blend_position", self.last_facing_direction)
	self.animation_tree.set("parameters/Run/blend_position", self.last_facing_direction)
