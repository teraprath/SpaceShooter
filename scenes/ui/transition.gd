extends CanvasLayer

var next_scene : String;

func go_to_next_scene():
	$AnimationPlayer.play("transition");

func change():
	get_tree().change_scene_to_file(next_scene);
