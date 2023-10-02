extends Area2D

func _on_area_entered(area):
	if area.is_in_group("bullets"):
		if area.body_target == "player":
			area.call_deferred("destroy");
			Global.shakeCamera(20);
		
func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.call_deferred("damage", 100);
		Global.shakeCamera(200);

func _on_self_destruct_timer_timeout():
	if Global.renew_shield == 0:
		$AnimationPlayer.play("despawn");
	else:
		Global.renew_shield -= 1;
		
func destruct():
	if Global.renew_shield > 0:
		Global.renew_shield -= 1;
		$AnimationPlayer.play_backwards("despawn");
	else:
		queue_free();
