extends Node

@export var initial_state : State

var current_state : State
var states : Dictionary = {}


func _ready():
	for child in get_children():
		if child is State:
			self.states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
	if self.initial_state:
		self.initial_state.enter()
		self.current_state = initial_state


func _process(delta):
	if self.current_state:
		self.current_state.update(delta)


func _physics_process(delta):
	if self.current_state:
		self.current_state.physics_update(delta)


func on_child_transition(state : State, new_state_name : String) -> void:
	if self.current_state != state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		return
	
	if self.current_state:
		self.current_state.exit()
	
	new_state.enter()
	self.current_state = new_state
