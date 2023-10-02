extends Node

signal health_update;
signal score_update;
signal player_death;
signal shield_renew;
signal title;
signal subtitle;

const player_default_health : int = 100;
const player_default_speed: int = 200;
const player_default_shoot_speed: int = 1500;
const player_default_damage : int = 10;

var config = ConfigFile.new();

var player_max_health = player_default_health;
var player_damage : int = player_default_damage;
var player_shoot_speed: int = player_default_shoot_speed;

var max_render_range: float = 2500.0;
var max_bullet_render_range: float = 1350;
var max_entities: int = 25;

var background : bool = true;

var enable_screen_shake = true;
var graphics : String = "High";
var keymap : bool = true;
var input_mode: String = "Keyboard";
var msaa = Viewport.MSAA_2X;
var music : bool = true;
var sfx : bool = true;
var zoom_level : int = 2;
var crosshair : int = 1;
var gamepad_mode = "playstation";


var highscore : int = 0;

var is_logging : bool = false;
var killstreak : int = 0:
	get:
		return killstreak;
	set(value):
		killstreak = value;
		if killstreak == 1 && is_logging == false:
			GlobalTimer.start_combat_log();
			is_logging = true;
			

var renew_shield : int = 0:
	get:
		return renew_shield;
	set(value):
		renew_shield = value;
		shield_renew.emit();

var player_health : int = player_default_health:
	get:
		return player_health;
	set(value):
		player_health = value;
		health_update.emit();
		if (player_health <= 0):
			player_death.emit();
	
var player_speed : int = player_default_speed;

var player_score : int = 0:
	get:
		return player_score;
	set(value):
		player_score = value;
		score_update.emit();

var entity_container : Node2D;
var player : CharacterBody2D;

var ability : bool = false:
	get:
		return ability;
	set(value):
		ability = value;
		
var ultimate : bool = false:
	get:
		return ultimate;
	set(value):
		ultimate = value;
		
func _ready():
	loadGlobal();

func _process(_delta):
	
	if Input.is_action_just_pressed("fullscreen"):
		toggleFullscreen();
		
func toggleFullscreen():
	if (DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);

func shakeCamera(offset: int):
	if enable_screen_shake:
		var tween : Tween = create_tween();
		var camera : Camera2D = player.get_node("Camera2D") as Camera2D;
		tween.tween_property(camera, "position", Vector2(offset, offset), 0.08);
		tween.tween_property(camera, "position", Vector2(-offset, -offset), 0.08);
		tween.tween_property(camera, "position", Vector2(offset, -offset), 0.08);
		tween.tween_property(camera, "position", Vector2(-offset, offset), 0.08);
		tween.tween_property(camera, "position", Vector2(0, 0), 0.5);

func reset():
	player_speed = player_default_speed;
	player_max_health = player_default_health;
	player_health = player_max_health;
	player_shoot_speed = player_default_shoot_speed;
	player_damage = player_default_damage;
	player_score = 0;
	
func saveGlobal():
	config.set_value("Stats", "highscore", highscore);
	config.set_value("Settings", "enable_screen_shake", enable_screen_shake);
	config.set_value("Settings", "graphics", graphics);
	config.set_value("Settings", "keymap", keymap);
	config.set_value("Settings", "input_mode", input_mode);
	config.set_value("Settings", "music", music);
	config.set_value("Settings", "sfx", sfx);
	config.set_value("Settings", "zoom_level", zoom_level);
	config.set_value("Settings", "msaa", msaa);
	config.set_value("Settings", "crosshair", crosshair);
	config.set_value("Settings", "gamepad_mode", gamepad_mode);
	config.save("user://global.cfg")
	
func loadGlobal():
	var err = config.load("user://global.cfg")

	if err != OK:
		return;
	
	highscore = config.get_value("Stats", "highscore");
	enable_screen_shake = config.get_value("Settings", "enable_screen_shake");
	graphics = config.get_value("Settings", "graphics");
	keymap = config.get_value("Settings", "keymap");
	input_mode = config.get_value("Settings", "input_mode");
	music = config.get_value("Settings", "music");
	sfx = config.get_value("Settings", "sfx");
	zoom_level = config.get_value("Settings", "zoom_level");
	msaa = config.get_value("Settings", "msaa");
	background = config.get_value("Settings", "background");
	crosshair = config.get_value("Settings", "crosshair");
	gamepad_mode = config.get_value("Settings", "gamepad_mode");
	
func save_game():
	config.set_value("Saved", "player_score", player_score);
	config.set_value("Saved", "player_health", player_health);
	config.save("user://global.cfg")
	
func load_game():
	Global.player_score = config.get_value("Saved", "player_score");
	Global.player_health = config.get_value("Saved", "player_health");


var titleList : Array[String] = [];
var subtitleList : Array[String] = [];
func alert(type: String, message: String):
	if type == "title":
		titleList.push_back(message);
		title.emit();
	if type == "subtitle":
		subtitleList.push_back(message);
		subtitle.emit();

func set_crosshair():
	Input.set_custom_mouse_cursor(load("res://assets/ui/cursor/crosshair/crosshair" + str(Global.crosshair) + ".png"), Input.CURSOR_ARROW, Vector2(64, 64));
	
func set_cursor():
	Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW, Vector2(0, 0));
