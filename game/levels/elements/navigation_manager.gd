extends Node

const scene_room = preload("res://game/levels/room/Room.tscn")
const scene_start = preload("res://game/levels/start/Start.tscn")

signal on_trigger_player_spawn

var spawn_door_tag

func go_to_level(level_tag, destination_tag) -> void:
	var scene_to_load 
	
	match level_tag:
		"start":
			scene_to_load = self.scene_start
		"room":
			scene_to_load = self.scene_room
	
	if scene_to_load != null:
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		self.spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed.call_deferred(scene_to_load)


func trigger_player_spawn(position : Vector2, direction : String) -> void:
	on_trigger_player_spawn.emit(position, direction)
