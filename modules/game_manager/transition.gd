extends CanvasLayer

var scene = null
var scene_change_queued = false
var progress = []

func _ready() -> void:
	self.visible = true
	$ColorRect/ProgressBar.visible = false
	$ColorRect.modulate = Color(1,1,1,0)

func _process(delta: float) -> void:
	if scene != null and scene_change_queued:
		ResourceLoader.load_threaded_get_status(scene, progress)
		if progress[0] == 1:
			scene_change_queued = false
			#self.visible = false
			$ColorRect/ProgressBar.visible = false
			fade_animation(false, 0.4)
			get_tree().change_scene_to_packed.bind(ResourceLoader.load_threaded_get(scene)).call_deferred()
		$ColorRect/ProgressBar.value = progress[0]
		

func await_scene_change(scene:String):
	scene_change_queued = true
	self.scene = scene
	#self.visible = true
	$ColorRect/ProgressBar.visible = true
	fade_animation(true, 0.4)
	#progress[0]

var fade_tween:Tween
func fade_animation(state:bool, time:float):
	if fade_tween:
		fade_tween.kill()
	fade_tween = create_tween()
	$ColorRect.modulate = Color(1,1,1, !state)
	fade_tween.tween_property($ColorRect, "modulate", Color(1,1,1, state), time)
	
