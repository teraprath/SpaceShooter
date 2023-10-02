extends CharacterBody2D

signal shoot(direction: Vector2);
signal dash;
signal dash_delay_timeout;

var can_attack : bool = true;
var zoomed_out : bool = false;
var is_alive : bool = true;
var can_dash : bool = true;


func _ready():
	Global.player = self;
	Global.connect("player_death", die);
	update_zoom();

func _process(delta):
	
	if is_alive:
		var direction : Vector2 = Input.get_vector("left", "right", "up", "down");
		velocity = direction * Global.player_speed;
		move_and_slide();
		GlobalBackground.offset(direction, Global.player_speed, delta);
		
		if Global.input_mode == "Keyboard":
			look_at(get_global_mouse_position());
		elif Global.input_mode == "Gamepad":
			var joy_stick : Vector2 = Input.get_vector("rotate_left", "rotate_right", "rotate_up", "rotate_down");
			look_at(global_transform.origin + joy_stick);
		
		if Input.is_action_pressed("shoot") && can_attack:
			if GlobalTimer.ability_is_active == false:
				can_attack = false;
			$AnimationPlayer.play("attack");
			$Timer/ShootDelayTimer.start();
			
		if Input.is_action_pressed("dash") && can_dash && GlobalTimer.ultimate_is_active == false:
			can_dash = false;
			Global.player_speed *= 4;
			$Timer/DashTimer.start();
			$Particles/SpeedParticles.emitting = true;
			$Timer/DashDelayTimer.start();
			dash.emit();
			
func update_zoom():
	if Global.zoom_level == 1:
		$Camera2D.zoom = Vector2(0.6, 0.6);
	elif Global.zoom_level == 2:
		$Camera2D.zoom = Vector2(0.8, 0.8);
	elif Global.zoom_level == 3:
		$Camera2D.zoom = Vector2(1, 1);
	elif Global.zoom_level == 4:
		$Camera2D.zoom = Vector2(1.2, 1.2);

func damage(amount: int):
	Global.player_health -= amount;
	Global.shakeCamera(50);


func heal(amount: int):
	Global.player_health += amount;

func _on_shoot_delay_timer_timeout():
	can_attack = true;

func shoot_bullet():
	var direction : Vector2;
	if Global.input_mode == "Keyboard":
		direction = (get_global_mouse_position() - position).normalized();
	elif Global.input_mode == "Gamepad":
		var forward_vector = Vector2(1,0);
		direction = (to_global(forward_vector) - position).normalized();
	shoot.emit(direction);

func die():
	is_alive = false;
	$AnimationPlayer.play("die");

func _on_dash_timer_timeout():
	Global.player_speed = Global.player_default_speed;
	$Particles/SpeedParticles.emitting = false;

func _on_dash_delay_timer_timeout():
	can_dash = true;
	dash_delay_timeout.emit();
