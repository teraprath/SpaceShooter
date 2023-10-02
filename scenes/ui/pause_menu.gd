extends CanvasLayer

func _on_resume_button_pressed():
	get_parent().pause();

func _on_menu_button_pressed():
	get_parent().pause();
	Global.save_game();
	Transition.next_scene = "res://scenes/ui/main_menu_wrapper.tscn";
	Transition.go_to_next_scene();

func focus():
	%ResumeButton.grab_focus();
