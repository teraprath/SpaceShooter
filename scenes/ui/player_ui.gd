extends CanvasLayer

@onready var shieldIcon : PackedScene = preload("res://scenes/ui/shield_icon.tscn");

func _ready():
	
	Global.connect("health_update", update_health);
	Global.connect("score_update", update_score);
	Global.connect("shield_renew", update_shield_icons);
	GlobalTimer.connect("ability_timeout", ability_timeout);
	GlobalTimer.connect("ability_progress_start", ability_progress_start);
	GlobalTimer.connect("ultimate_timeout", ultimate_timeout);
	GlobalTimer.connect("ultimate_progress_start", ultimate_progress_start);
	Global.player.connect("dash", player_dash);
	Global.player.connect("dash_delay_timeout", dash_delay_timeout);

	%HealthBar.max_value = Global.player_max_health;
	%HealthBar.value = Global.player_health;
	%HealthBarLayer.max_value = Global.player_max_health;
	%HealthBarLayer.value = Global.player_health;
	
	%Score.text = str(Global.player_score);
	
	update_actions();
	
	if Global.keymap:
		var keymap = preload("res://scenes/ui/keymap.tscn");
		%ActionContainer.add_child(keymap.instantiate());
		
func update_actions():
	%AbilityProgress.max_value = GlobalTimer.get_ability_timer().wait_time;
	%UltimateProgress.max_value = GlobalTimer.get_ultimate_timer().wait_time;
		
func _process(_delta):
	%AbilityProgress.value = GlobalTimer.get_ability_timer().wait_time - GlobalTimer.get_ability_timer().time_left;
	%UltimateProgress.value = GlobalTimer.get_ultimate_timer().wait_time - GlobalTimer.get_ultimate_timer().time_left;
	
func update_health():
	var tween : Tween = create_tween();
	tween.set_parallel(true);
	tween.tween_property(%HealthBar, "value", Global.player_health, 1);
	tween.tween_property(%HealthBarLayer, "value", Global.player_health, 0.2);

func update_score():
	%Score.text = str(Global.player_score);
	var tween : Tween = create_tween();
	tween.tween_property(%Score, "rotation", -0.025, 0.1);
	tween.tween_property(%Score, "rotation", 0.025, 0.2);
	tween.tween_property(%Score, "rotation", 0, 0.1);
	
func update_shield_icons():
	if %ShieldContainer.get_child_count() > Global.renew_shield:
		%ShieldContainer.remove_child(%ShieldContainer.get_child(0));
	elif %ShieldContainer.get_child_count() < Global.renew_shield:
		var icon = shieldIcon.instantiate();
		%ShieldContainer.add_child(icon);

func ability_timeout():
	%AbilityProgress.modulate = Color("ffffff");
	
func ability_progress_start():
	%AbilityProgress.modulate = Color("ffffff32");
	
func ultimate_timeout():
	%UltimateProgress.modulate = Color("ffffff");
	
func ultimate_progress_start():
	%UltimateProgress.modulate = Color("ffffff32");
	
func player_dash():
	%DashProgress.value = 0;
	pass;
	
func dash_delay_timeout():
	%DashProgress.value = 1;
	pass
