extends Node2D

const bullet : PackedScene = preload("res://scenes/objects/bullet.tscn");

func _ready():
	Global.connect("player_death", show_game_over_screen);
	Global.entity_container = $Entities;
	GlobalTimer.start_ability_timer();
	GlobalTimer.start_ultimate_timer();
	Global.set_crosshair();
	
func _process(_delta):
	
	if Input.is_action_just_pressed("escape"):
		pause();
		
	if Input.is_action_pressed("ability"):
		if Global.ability && GlobalTimer.ability_is_active == false:
			GlobalTimer.start_ability_timer();
			GlobalTimer.set_ability_active();
			
	if Input.is_action_pressed("ultimate"):
		if Global.ultimate:
			GlobalTimer.start_ultimate_timer();
			GlobalTimer.set_ultimate_active();

func _on_player_shoot(direction):
	var newBullet = bullet.instantiate();
	newBullet.position = $Player.position;
	newBullet.look_at(direction);
	newBullet.direction = direction;
	newBullet.damage = Global.player_damage;
	newBullet.speed = Global.player_shoot_speed;
	
	if GlobalTimer.ability_is_active:
		newBullet.set_on_fire();
		
	if GlobalTimer.ultimate_is_active:
		newBullet.speed += Global.player_shoot_speed;		
	
	$Bullets.add_child(newBullet);

func show_game_over_screen():
	$PlayerUI.visible = false;
	$DeathMenu.visible = true;
	$DeathMenu.focus();
	
	Global.saveGlobal();
	Global.set_cursor();
	
func pause():
	if $PauseMenu.visible:
		$PauseMenu.visible = false;
		$Player.process_mode = Node.PROCESS_MODE_ALWAYS;
		$Bullets.process_mode = Node.PROCESS_MODE_ALWAYS;
		$Entities.process_mode = Node.PROCESS_MODE_ALWAYS;
		GlobalTimer.process_mode = Node.PROCESS_MODE_ALWAYS;
		Global.set_crosshair();
	else:
		$PauseMenu.visible = true;
		$Player.process_mode = Node.PROCESS_MODE_DISABLED;
		$Bullets.process_mode = Node.PROCESS_MODE_DISABLED;
		$Entities.process_mode = Node.PROCESS_MODE_DISABLED;
		GlobalTimer.process_mode = Node.PROCESS_MODE_DISABLED;
		if Global.input_mode == "Gamepad":
			$PauseMenu.focus();
		Global.set_cursor();
