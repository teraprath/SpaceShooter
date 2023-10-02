extends Node

signal ability_timeout;
signal ability_progress_start;
signal ultimate_timeout;
signal ultimate_progress_start;

var ability_is_active : bool = false;
var ultimate_is_active : bool = false;

@onready var ability_timer : Timer = get_node("AbilityTimer");
@onready var ultimate_timer : Timer = get_node("UltimateTimer");
@onready var ability_active_timer : Timer = get_node("AbilityActiveTimer");
@onready var ultimate_active_timer : Timer = get_node("UltimateActiveTimer");

func get_ability_timer() -> Timer:
	return ability_timer;

func start_ability_timer():
	Global.ability = false;
	ability_timer.start();
	ability_progress_start.emit();
	
func get_ultimate_timer() -> Timer:
	return ultimate_timer;

func start_ultimate_timer():
	Global.ultimate = false;
	ultimate_timer.start();
	ultimate_progress_start.emit();
	
func stop_game_timer():
	Global.ability = false;
	Global.ultimate = false;
	ability_timer.stop();
	ultimate_timer.stop();

func _on_ability_timer_timeout():
	Global.ability = true;
	ability_timeout.emit();

func _on_ultimate_timer_timeout():
	Global.ultimate = true;
	ultimate_timeout.emit()

func _on_activity_active_timer_timeout():
	ability_is_active = false;
	
func set_ability_active():
	ability_is_active = true;
	ability_active_timer.start();
	
func _on_ultimate_active_timer_timeout():
	ultimate_is_active = false;
	Global.player_speed = Global.player_default_speed;
	Global.player.get_node("Particles/SpeedParticles").emitting = false;
	
func set_ultimate_active():
	ultimate_is_active = true;
	ultimate_active_timer.start();
	Global.player_speed = Global.player_speed * 2;
	Global.player.get_node("Particles/SpeedParticles").emitting = true;

func _on_killstreak_timer_timeout():
	if Global.killstreak > 3:
		Global.alert("title", "MULTI KILL");
		Global.player_score += 400;
	elif Global.killstreak > 2:
		Global.alert("title", "TRIPLE KILL")
		Global.player_score += 300;
	elif Global.killstreak > 1:
		Global.alert("title", "DOUBLE KILL")
		Global.player_score += 200;
	Global.killstreak = 0;
	Global.is_logging = false;

func start_combat_log():
	$KillstreakTimer.start();
