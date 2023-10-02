extends CanvasLayer

func _ready():
	updateSettings();
	if Global.input_mode == "Gamepad":
		%Menu.get_child(0).grab_focus();
		
	if Global.player_score == 0:
		%Menu/LoadGameButton.disabled = true;
		
	%Page2/CrosshairButton.icon = load("res://assets/ui/cursor/crosshair/crosshair" + str(Global.crosshair) + ".png");
	Global.set_cursor();
		
func _process(delta):
	if Global.input_mode == "Keyboard":
		GlobalBackground.follow_mouse(delta);
		
func _on_new_game_button_pressed():
	Global.reset();
	Transition.next_scene = "res://scenes/levels/level.tscn";
	Transition.go_to_next_scene();

func _on_load_game_button_pressed():
	Transition.next_scene = "res://scenes/levels/level.tscn";
	Transition.go_to_next_scene();
	Global.load_game();

func _on_quit_button_pressed():
	get_tree().quit();

func _on_settings_button_pressed():
	updateSettings();
	%Menu.visible = false;
	%Settings.visible = true;
	if Global.input_mode == "Gamepad":
		%Settings.get_child(0).get_child(0).get_child(0).grab_focus();

func _on_back_button_pressed():
	Global.saveGlobal();
	%Menu.visible = true;
	%Settings.visible = false;
	if Global.input_mode == "Gamepad":
		%Menu.get_child(0).grab_focus();

func _on_fullscreen_button_pressed():
	Global.toggleFullscreen();
	updateSettings();
	
func _on_graphics_button_pressed():
	if Global.graphics == "Low":
		Global.graphics = "Medium";
	elif Global.graphics == "Medium":
		Global.graphics = "High";
	elif Global.graphics == "High":
		Global.graphics = "Low";
	updateSettings();
	
func _on_screen_shake_button_pressed():
	if Global.enable_screen_shake:
		Global.enable_screen_shake = false;
	else:
		Global.enable_screen_shake = true;
	updateSettings();
	
func _on_keymap_button_pressed():
	if Global.keymap:
		Global.keymap = false;
	else:
		Global.keymap = true;
	updateSettings();
	
func _on_input_button_pressed():
	if Global.input_mode == "Keyboard":
		Global.input_mode = "Gamepad";
	elif Global.input_mode == "Gamepad":
		Global.input_mode = "Keyboard";
	updateSettings();
	
func _on_music_button_pressed():
	if Global.music:
		Global.music = false;
	else:
		Global.music = true;
	updateSettings();
	
func _on_sfx_button_pressed():
	if Global.sfx:
		Global.sfx = false;
	else:
		Global.sfx = true;
	updateSettings()
	
func _on_zoom_button_pressed():
	if Global.zoom_level == 4:
		Global.zoom_level = 1;
	else:
		Global.zoom_level += 1;
	updateSettings();
	
func _on_msaa_button_pressed():
	if Global.msaa == Viewport.MSAA_DISABLED:
		Global.msaa = Viewport.MSAA_2X;
	elif Global.msaa == Viewport.MSAA_2X:
		Global.msaa = Viewport.MSAA_4X;
	elif Global.msaa == Viewport.MSAA_4X:
		Global.msaa = Viewport.MSAA_8X
	elif Global.msaa == Viewport.MSAA_8X:
		Global.msaa = Viewport.MSAA_DISABLED;
	updateSettings();
	
func _on_gamepad_mode_button_pressed():
	if Global.gamepad_mode == "playstation":
		Global.gamepad_mode = "xbox";
	elif Global.gamepad_mode == "xbox":
		Global.gamepad_mode = "playstation";
	updateSettings();

func _on_crosshair_button_pressed():
	if Global.crosshair < 9:
		Global.crosshair += 1;
	else:
		Global.crosshair = 1;
	%Page2/CrosshairButton.icon = load("res://assets/ui/cursor/crosshair/crosshair" + str(Global.crosshair) + ".png");
	

func updateSettings():
	
	if (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN):
		%Page1/FullscreenButton.text = "Fullscreen: ON";
	else:
		%Page1/FullscreenButton.text = "Fullscreen: OFF";
		
	if Global.enable_screen_shake:
		%Page1/ScreenShakeButton.text = "Screen Shake: ON";
	else:
		%Page1/ScreenShakeButton.text = "Screen Shake: OFF";
		
	%Page1/GraphicsButton.text = "Graphics: " + Global.graphics;
	
	if Global.keymap:
		%Page1/KeymapButton.text = "Show Controls: ON";
	else:
		%Page1/KeymapButton.text = "Show Controls: OFF";
	
	if Global.input_mode == "Keyboard":
		%Page1/InputButton.text = "Input: Keyboard";
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	elif Global.input_mode == "Gamepad":
		%Page1/InputButton.text = "Input: Gamepad";
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN);
		
	if Global.music:
		%Page2/MusicButton.text = "Music: ON";
	else:
		%Page2/MusicButton.text = "Music: OFF";
		
	if Global.sfx:
		%Page2/SFXButton.text = "SFX: ON";
	else:
		%Page2/SFXButton.text = "SFX: OFF";
		
	if Global.msaa == Viewport.MSAA_DISABLED:
		%Page2/MSAAButton.text = "MSAA: Disabled";
	elif Global.msaa == Viewport.MSAA_2X:
		%Page2/MSAAButton.text = "MSAA: 2x";
	elif Global.msaa == Viewport.MSAA_4X:
		%Page2/MSAAButton.text = "MSAA: 4x";
	elif Global.msaa == Viewport.MSAA_8X:
		%Page2/MSAAButton.text = "MSAA: 8x";
		
	if Global.gamepad_mode == "xbox":
		%Page2/GamepadModeButton.text = "Mode: Xbox";
	elif Global.gamepad_mode == "playstation":
		%Page2/GamepadModeButton.text = "Mode: PlaySation";
		
	%Page2/ZoomButton.text = "Zoom Level: " + str(Global.zoom_level);
	
	get_viewport().msaa_2d = Global.msaa;
	GlobalBackground.update();
	GlobalWorldEnvironment.updateGraphics();

	if Global.input_mode == "Gamepad":
		%Page2/CrosshairButton.visible = false;
		%Page2/GamepadModeButton.visible = true;
	else:
		%Page2/GamepadModeButton.visible = false;
		%Page2/CrosshairButton.visible = true;
