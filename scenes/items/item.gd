extends Area2D;
class_name ItemParent;

func _on_body_entered(body):
	if body.is_in_group("player"):
		collect();
		queue_free();
		
func idle():
	$AnimationPlayer.play("idle");
		
func collect():
	pass;

func _on_despawn_timer_timeout():
	$AnimationPlayer.play("despawn");
