class_name StateQueue
extends GDScript

var queue: Array[int] = []

func _init(initial_states: Array[int]):
	if initial_states != null:
		for state in initial_states:
			queue.push_back(state)

func pop() -> int:
	return queue.pop_front()

func push(state: int):
	queue.push_back(state)

func first() -> int:
	if queue.size() > 0:
		return queue[0]
	else:
		return 0

func clear():
	queue.clear()

func replace(state: int) -> State:
	var old_state = queue.pop_back()

	push(state)

	return old_state

func size() -> int:
	return queue.size()
