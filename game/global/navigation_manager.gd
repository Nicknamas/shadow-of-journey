extends Node

const NAME_NODE_CONSTRUCTOR = "RoomConstuctor"
const LOCATIONS = ["start", "test"]

enum LOCATIONS_NAME {
	START = 0,
	TEST = 1,
}

const scene_start = preload("res://game/world/World.tscn")
const scene_room = preload("res://game/levels/dungeon/rooms/Room.tscn")
const scene_test = preload("res://game/levels/test/Test.tscn")

signal on_navigate

var spawn_door_tag : String
var cached_rooms : Dictionary
var level_tag : String
var scene_to_load : Resource


func go_to_level(level_tag : String, destination_door_tag : String) -> void:
	self.init_values(level_tag, destination_door_tag)
	await self.transition()
	if self.is_location():
		self.load_location()
	elif self.scene_to_load != null:
		self.change_room()
		on_navigate.emit(level_tag)


func transition() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished


func init_values(level_tag : String, destination_door_tag : String) -> void:
	self.level_tag = level_tag
	self.spawn_door_tag = destination_door_tag
	self.scene_to_load = self.get_scene_to_load()


func load_location() -> void:
	if "start" in self.level_tag:
		get_tree().change_scene_to_packed(self.scene_start)
	elif "test" in self.level_tag:
		get_tree().change_scene_to_packed(self.scene_test)


func is_location() -> bool:
	var is_start_location = self.LOCATIONS[self.LOCATIONS_NAME.START] in self.level_tag
	var is_test_location = self.LOCATIONS[self.LOCATIONS_NAME.TEST] in self.level_tag
	return is_start_location or is_test_location


func get_scene_to_load() -> Resource:
	if "room" in self.level_tag:
		return self.scene_room
	return null


func change_room() -> void:
	var level = get_node("/root/World/Level") as Node
	var old_room = level.get_child(0)
	var door = get_door(old_room) as Door
	var new_room = get_new_room()
	#if not self.cached_rooms.has(self.level_tag):
		#cach_room(new_room)
	self.switch_rooms(level, old_room, new_room)
	self.change_hero_position(door.spawn.global_position)
	self.change_hero_parent(new_room)


func switch_rooms(parent : Node, old : Node, new : Node) -> void:
	parent.remove_child(old)
	old.queue_free()
	parent.add_child(new)


func get_door(room: Node) -> Door:
	var doors = room.get_node("Doors")
	var door_path = "Door_" + self.spawn_door_tag
	var door = doors.get_node(door_path) as Door
	return door


func change_hero_position(spawn_position: Vector2) -> void:
	var hero = self.get_hero()
	hero.global_position = spawn_position


func change_hero_parent(new_parent) -> void:
	var hero = get_hero()
	hero.reparent(new_parent)


func get_hero() -> Hero:
	var hero = get_tree().get_first_node_in_group("Hero") as Hero
	return hero


func get_new_room() -> Node:
	if self.cached_rooms.has(self.level_tag):
		return self.cached_rooms[self.level_tag]
	else:
		return self.scene_to_load.instantiate() as Node


func cach_room(room : Node) -> void:
	self.cached_rooms[self.level_tag] = room
