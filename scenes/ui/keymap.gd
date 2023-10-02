extends HBoxContainer

func _ready():
	if Global.input_mode == "Keyboard":
		$KeyboardDash.visible = true;
		$KeyboardAbility.visible = true;
		$KeyboardUltimate.visible = true;
	elif Global.input_mode == "Gamepad":
		if Global.gamepad_mode == "playstation":
			$PlayStationDash.visible = true;
			$PlayStationAbility.visible = true;
			$PlayStationUltimate.visible = true;
		elif Global.gamepad_mode == "xbox":
			$XboxDash.visible = true;
			$XboxAbility.visible = true;
			$XboxUltimate.visible = true;
