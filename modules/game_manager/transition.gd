extends CanvasLayer

var scene = null
var scene_change_queued = false
var progress = []

func _process(delta: float) -> void:
	if scene != null and scene_change_queued:
		ResourceLoader.load_threaded_get_status(scene, progress)
		if progress[0] == 1:
			scene_change_queued = false
			self.visible = false
			get_tree().change_scene_to_packed.bind(ResourceLoader.load_threaded_get(scene)).call_deferred()
		$ProgressBar.value = progress[0]
		



func await_scene_change(scene:String):
	scene_change_queued = true
	self.scene = scene
	self.visible = true
	#progress[0]
