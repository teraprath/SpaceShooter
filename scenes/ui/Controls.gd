extends VBoxContainer

func _ready():
	if Global.keymap:
		visible = true;
		if Global.input_mode == "Keyboard":
			for node in get_children():
				node.get_node("keyboard").visible = true;
		elif Global.input_mode == "Gamepad":
			for node in get_children():
				node.get_node(Global.gamepad_mode).visible = true;
