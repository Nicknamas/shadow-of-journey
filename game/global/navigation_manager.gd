extends Node

const scene_start = preload("res://game/world/World.tscn")
const scene_room4E = preload("res://game/levels/dungeon/rooms/Room4E.tscn")
const scene_room3E1 = preload("res://game/levels/dungeon/rooms/Room3E1.tscn")
const scene_room3E2 = preload("res://game/levels/dungeon/rooms/Room3E2.tscn")
const scene_room3E3 = preload("res://game/levels/dungeon/rooms/Room3E3.tscn")
const scene_room3E4 = preload("res://game/levels/dungeon/rooms/Room3E4.tscn")
const scene_room2E1 = preload("res://game/levels/dungeon/rooms/Room2E1.tscn")
const scene_room2E2 = preload("res://game/levels/dungeon/rooms/Room2E2.tscn")
const scene_room2E3 = preload("res://game/levels/dungeon/rooms/Room2E3.tscn")
const scene_room2E4 = preload("res://game/levels/dungeon/rooms/Room2E4.tscn")
const scene_room2E5 = preload("res://game/levels/dungeon/rooms/Room2E5.tscn")
const scene_room2E6 = preload("res://game/levels/dungeon/rooms/Room2E6.tscn")
const scene_room1E1 = preload("res://game/levels/dungeon/rooms/Room1E1.tscn")
const scene_room1E2 = preload("res://game/levels/dungeon/rooms/Room1E2.tscn")
const scene_room1E3 = preload("res://game/levels/dungeon/rooms/Room1E3.tscn")
const scene_room1E4 = preload("res://game/levels/dungeon/rooms/Room1E4.tscn")

signal on_trigger_player_spawn
signal on_navigate

var spawn_door_tag

func go_to_level(level_tag : String, destination_tag) -> void:
	var scene_to_load 

	if "start" in level_tag:
		scene_to_load = self.scene_start
	elif "room4E" in level_tag:
		scene_to_load = self.scene_room4E
	elif "room3E1" in level_tag:
		scene_to_load = self.scene_room3E1
	elif "room3E2" in level_tag:
		scene_to_load = self.scene_room3E2
	elif "room3E3" in level_tag:
		scene_to_load = self.scene_room3E3
	elif "room3E4" in level_tag:
		scene_to_load = self.scene_room3E4
	elif "room2E1" in level_tag:
		scene_to_load = self.scene_room2E1
	elif "room2E2" in level_tag:
		scene_to_load = self.scene_room2E2
	elif "room2E3" in level_tag:
		scene_to_load = self.scene_room2E3
	elif "room2E4" in level_tag:
		scene_to_load = self.scene_room2E4
	elif "room2E5" in level_tag:
		scene_to_load = self.scene_room2E5
	elif "room2E6" in level_tag:
		scene_to_load = self.scene_room2E6
	elif "room1E1" in level_tag:
		scene_to_load = self.scene_room1E1
	elif "room1E2" in level_tag:
		scene_to_load = self.scene_room1E2
	elif "room1E3" in level_tag:
		scene_to_load = self.scene_room1E3
	elif "room1E4" in level_tag:
		scene_to_load = self.scene_room1E4
	
	if "start" in level_tag:
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		self.spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_start)
	elif scene_to_load != null:
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		self.spawn_door_tag = destination_tag
		var init_room = scene_to_load.instantiate() as Node
		var level = get_node("/root/World/Level") as Node
		var room = level.get_child(0)
		level.remove_child(room)
		room.queue_free()
		level.add_child(init_room)
		on_navigate.emit(level_tag)


func trigger_player_spawn(position : Vector2, direction : String) -> void:
	on_trigger_player_spawn.emit(position, direction)
