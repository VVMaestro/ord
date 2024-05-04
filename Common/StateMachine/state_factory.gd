class_name StateFactory

var states_dict: Dictionary

func _init(initial_states: Array[Script]) -> void:
  for initial_state in initial_states:
    states_dict[initial_state.get_state_name()] = initial_state

func get_state(state_name: String) -> Script:
  assert(states_dict.has(state_name), "No state " + state_name + " in state factory")

  return states_dict.get(state_name)