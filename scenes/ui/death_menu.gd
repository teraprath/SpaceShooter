extends CanvasLayer

func _ready():
	Global.connect("player_death", on_death);

func _on_menu_button_pressed():
	Transition.next_scene = "res://scenes/ui/main_menu_wrapper.tscn";
	Transition.go_to_next_scene();
	Global.reset();
	
func _on_new_game_pressed():
	Transition.next_scene = "res://scenes/levels/level.tscn";
	Transition.go_to_next_scene();
	Global.reset();
	
func on_death():
	
	%Highscore.text = "Highscore: " + str(Global.highscore);
	%Score.text = "Score: " + str(Global.player_score);
	
	if Global.player_score > Global.highscore:
		%Highscore.text = "Highscore: " + str(Global.highscore);
		Global.highscore = Global.player_score;
		%Score.visible = false;
		%Record.visible = true;
		%Title.visible = false;

func focus():
	if Global.input_mode == "Gamepad":
		%MenuButton.grab_focus();
