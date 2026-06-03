class_name StatesConstants
extends Resource

enum State {
	BASE = 0,
	IDLE,
	RUN,
	MOVE,
	CLIMB,
}

const ANIM: Dictionary[String, String] = {
	"IDLE": 'idle',
	"RUN": 'run',
	"CLIMB": 'hit',
	"HIT": 'hit'
}
