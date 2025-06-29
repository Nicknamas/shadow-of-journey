class_name ProcedureGeneratorBranchesDungeon extends ProcedureGeneratoreLinearDungeon

@export var branches : int = 3
@export var branches_length : Vector2i = Vector2i(1, 3)


func _init():
	await super._ready()
	self.generate_branches()
	if debug:
		print("BRANCHED_PATH:")
		super.print_dungeons()


func generate_path(from_room : Room, length : int, marker : String) -> bool:
	if length == 0:
		return true
	var current_room : Room = from_room
	var direction : Vector2i = generate_random_direction()
	self.count_rooms += 1
	
	for i in 4:
		if (self.is_valid_path(current_room, direction)):
			var new_room = self.get_new_roow_with_marker_and_coords(marker, current_room.coords, direction)
			if marker == self.ROOM_TYPES.START_BRANCH:
				marker = self.ROOM_TYPES.BRANCH
			if self.generate_path(new_room, length - 1, marker):
				return true
			else:
				dungeon[new_room.coords.x][new_room.coords.y] = 0
		direction = Vector2(direction.y, -direction.x)
	self.count_rooms -= 1
	return false


func is_valid_path(current_room: Room, direction: Vector2i) -> bool:
	if not super.is_includes_coords_in_dungeon(current_room.coords, direction):
		return false
	var is_not_empty_room = dungeon[current_room.coords.x + direction.x][current_room.coords.y + direction.y]
	return not is_not_empty_room


func generate_branches() -> void:
	var branches_created : int = 0
	var candidate : Room
	while branches_created < self.branches and self.branch_canditates.size():
		candidate = self.get_random_branch_candidate()
		if self.generate_path(candidate, randi_range(branches_length.x, branches_length.y), ROOM_TYPES.START_BRANCH):
			branches_created += 1
		else:
			self.branch_canditates.erase(candidate)


func get_random_branch_candidate() -> Room:
	return self.branch_canditates[randi_range(0, self.branch_canditates.size() - 1)]
