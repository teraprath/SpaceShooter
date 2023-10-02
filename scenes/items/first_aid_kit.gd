extends ItemParent;

func collect():
	if Global.player_health < 60:
		Global.player_health += 40;
	else:
		Global.player_health = 100;
	Global.alert("subtitle", "+40 HP");
	Global.player_score += randi_range(100, 200);
