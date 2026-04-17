extends Node2D


var frequency = 0
var duration = 0
var amplitude = 0
var level = 0

@export var camera:Node = null
var duration_timer:Timer
#@onready var frequency_timer = Timer.new()

var tween:Tween

func _ready():
	#tween = create_tween()
	
	duration_timer = Timer.new()
	self.add_child(duration_timer)
	duration_timer.one_shot = true
	duration_timer.timeout.connect(_on_Duration_timeout)


func shake(duration = 0.4, amplitude = 16, frequency = 10, level = 0):
	if level >= self.level:
		self.level = level
		self.amplitude = amplitude
		self.frequency = frequency
		self.duration = duration
		
		duration_timer.wait_time = duration
		duration_timer.start()
		
		if tween:
			tween.kill()
		tween = self.create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		for i in range(floor(frequency * duration) - 1):
			screenshake()
		tween.tween_property(camera, "offset", Vector2(0,0), 1.0 / frequency)
		tween.finished.connect(_on_tween_finished)
		
		#print("shake")

func screenshake():
	var random = Vector2()
	random.x = randf_range(-amplitude, amplitude)
	random.y = randf_range(-amplitude, amplitude)
	
	tween.tween_property(camera, "offset", random, 1.0 / frequency)

func reset():
	camera.offset.x = 0
	camera.offset.y = 0
	level = 0
	#print("reset")

func _on_tween_finished():
	tween.kill()

func _on_Duration_timeout():
	reset()
