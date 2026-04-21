extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(1,20):
		abc(i)

func abc(level:int):
	print(level)
	var avg = 0
	var sample = []
	var sd = 0
	var count = 100
	for i in range(count):
		#var a = MathStuff.random_logarithmic(level + 1, 1.17, 0.40, 3.2)
		#var a = MathStuff.random_logarithmic(level + 2, 1.24, 0.24, 3.0)
		#var a = MathStuff.random_exponential(level, 1.05, 6.00, 4.20)
		var a = MathStuff.random_exponential(level, 1.11, 6.00, 5.20)
		#print(a)
		avg += a
		sample.append(a)
	avg /= count
	print("avg: " + str(avg))
	for a in sample:
		sd += (a - avg)**2
	sd = sqrt(sd / (count - 1))
	print("sd: " + str(sd))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
