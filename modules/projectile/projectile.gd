class_name Projectile

var velocity:Vector2
var spawn_time:int
var shape:RID
var linear_damp:float

func spawn_projectile(position:Vector2, velocity:Vector2):
	var instance:Projectile = Projectile.new()
	instance.velocity = velocity
	#instance.velocity = velocity
	instance.position = position
	
	
