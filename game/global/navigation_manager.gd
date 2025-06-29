extends Node

const scene_room = preload("res://game/levels/room/Room.tscn")
const scene_start = preload("res://game/levels/start/Start.tscn")

signal on_trigger_player_spawn
signal on_navigate

var spawn_door_tag

func go_to_level(level_tag, destination_tag) -> void:
	var scene_to_load 

	if level_tag == "start":
		scene_to_load = self.scene_start
	else:
		scene_to_load = self.scene_room


	if scene_to_load != null:
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		self.spawn_door_tag = destination_tag
		var init_room = scene_room.instantiate() as Node
		var level = get_node("/root/World/Level") as Node
		var room = level.get_child(0)
		level.remove_child(room)
		room.queue_free()
		level.add_child(init_room)
		on_navigate.emit(level_tag)


func trigger_player_spawn(position : Vector2, direction : String) -> void:
	on_trigger_player_spawn.emit(position, direction)
