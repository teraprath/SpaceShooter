extends Area2D

@export var speed : int = 0;

var body_target : String = "enemies";
var direction : Vector2 = Vector2.ZERO;
var damage : int = 0;
var destroyed = false;
var on_fire = false;

func _process(delta):
	
	if not destroyed:
		position += direction * speed * delta;
		if position.distance_to(Global.player.position) > Global.max_bullet_render_range:
			if body_target == "player":
				Global.player_score += randi_range(10, 20);
			queue_free();

func _on_body_entered(body):
	if body.is_in_group(body_target):
		body.damage(damage);
		queue_free();
		
func set_on_fire():
	on_fire = true;
	damage = damage * 4;
	$Sprite2D.self_modulate = Color("ebeb00");
	$Particles/SmokeParticles.emitting = true;

func _on_area_entered(area):
	if area.is_in_group("bullets") && area.body_target != body_target:
		destroy();
		
func destroy():
	destroyed = true;
	Global.player_score += randi_range(25, 50);
	$AnimationPlayer.play("destroy");
