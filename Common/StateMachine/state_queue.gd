class_name StateQueue
extends GDScript

var queue: Array[State] = []

func _init(initial_states: Array[State]):
	if initial_states != null:
		for state in initial_states:
			queue.push_back(state)

func pop() -> State:
	return queue.pop_front()

func push(state: State):
	queue.push_back(state)

func first() -> State:
	if queue.size() > 0:
		return queue[0]
	else:
		return null

func clear():
	queue.clear()

func replace(state: State) -> State:
	var old_state = queue.pop_back()

	push(state)

	return old_state

func size() -> int:
	return queue.size()
