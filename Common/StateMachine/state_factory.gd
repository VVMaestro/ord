class_name StateFactory
extends Node


var states_dict: Dictionary

func _init(initial_states: Array[Script]) -> void:
	for initial_state in initial_states:
		states_dict[initial_state.get_static_state_name()] = initial_state

func get_state(state_name: StatesConstants.State) -> Script:
	assert(states_dict.has(state_name), "No state %s in state factory" % state_name)

	return states_dict.get(state_name)
	
func get_state_by_tile_type(tile_type: TilemapConstants.TileType) -> State:
	var new_state: StatesConstants.State = StatesConstants.State.BASE
	
	match tile_type:
		TilemapConstants.TileType.PATH:
			new_state = StatesConstants.State.MOVE
		TilemapConstants.TileType.OBST:
			new_state = StatesConstants.State.IDLE
		TilemapConstants.TileType.CLIMB:
			new_state = StatesConstants.State.CLIMB
			
	assert(new_state != StatesConstants.State.BASE, "Base state is not allowed")
			
	return get_state(new_state).new()