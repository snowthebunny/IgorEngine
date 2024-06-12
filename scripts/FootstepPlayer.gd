extends AudioStreamPlayer3D

@onready var step_streams:Array[AudioStream] = [
	preload("res://audio/sounds/footsteps/fs-1.ogg"),
	preload("res://audio/sounds/footsteps/fs-2.ogg"),
	preload("res://audio/sounds/footsteps/fs-3.ogg"),
	preload("res://audio/sounds/footsteps/fs-4.ogg")
]
@onready var timer:Timer = Timer.new()

var can_step = true

func _ready():
	timer.wait_time = 0.5
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", _timer_timeout)

func step():
	if can_step:
		var stream_index = randi_range(0, (len(step_streams) - 1))
		stream = step_streams[stream_index]
		play()
		timer.start()
		can_step = false

func _timer_timeout():
	can_step = true
