class_name InputEventProcessor

var strategies: Dictionary[String, Callable] = {}

func _init() -> void:
	pass

func process(input_event: InputEvent) -> void:
	var input_event_name := input_event.get_class()
	
	if strategies.has(input_event_name):
		strategies.get(input_event_name).call(input_event)

	
func add_strategy(input_event: InputEvent, strategy: Callable) -> void:
	strategies.set(input_event.get_class(), strategy)