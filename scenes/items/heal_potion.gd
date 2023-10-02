extends ItemParent

func collect():
	if Global.player_health < 80:
		Global.player_health += 20;
	else:
		Global.player_health = 100;
	Global.alert("subtitle", "+20 HP");
	Global.player_score += randi_range(50, 150);
