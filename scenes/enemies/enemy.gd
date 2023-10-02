extends CharacterBody2D
class_name EnemyParent

@onready var level : Node2D = get_parent().get_parent().get_node("Bullets") as Node2D;
@onready var first_aid_kit = preload("res://scenes/items/first_aid_kit.tscn");
@onready var heal_potion = preload("res://scenes/items/heal_potion.tscn");
@onready var shield_item = preload("res://scenes/items/shield_item.tscn");

@export var speed : int = 150;
@export var health : int = 20;
@export var min_player_distance : int = 800;
@export var max_player_distance : int = 200;
@export var min_score : int = 10;
@export var max_score : int = 20;
@export var bullet_speed : int = 600;
@export var enemy_damage : int = 10;
@export var explosion_damage : int = 15;
@export var can_shoot : bool = true;
@export var is_dead : bool = false;

const bullet : PackedScene = preload("res://scenes/objects/bullet.tscn");

var can_take_damage : bool = true;

func _process(_delta):
	
	if Global.player.is_alive:
		var direction : Vector2 = (Global.player.global_position - position).normalized();
		var player_distance : float = position.distance_to(Global.player.position);
		
		look_at(Global.player.position);
		
		if player_distance > max_player_distance:
			velocity = direction * speed;
			move_and_slide();
		
		if player_distance <= min_player_distance && can_shoot:
			can_shoot = false;
			$AnimationPlayer.play("shoot");
			$Timer/ShootDelayTimer.start();
			
		if player_distance > Global.max_render_range:
			Global.player.get_node("Spawner").spawn_enemy();
			print("respawn");
			queue_free();

func damage(amount: int):
	if can_take_damage:
		health -= amount;
		if (health <= 0):
			Global.player_score += randi_range(min_score, max_score);		
			$AnimationPlayer.play("death");
		else:
			can_take_damage = false;
			$AnimationPlayer.play("hit");
			$Timer/DamageTimer.start();
		Global.player_score += randi_range(5, 10);
			
func drop_loot():
	var rnd = randi_range(1, 100);
	if rnd > 95:
		var item = first_aid_kit.instantiate();
		item.position = position;
		Global.entity_container.add_child(item);
	elif rnd > 80:
		var item = heal_potion.instantiate();
		item.position = position;
		Global.entity_container.add_child(item);
	elif rnd > 70:
		var item = shield_item.instantiate();
		item.position = position;
		Global.entity_container.add_child(item);
	
func heal(amount: int):
	health += amount;
	
func shoot():
	var newBullet = bullet.instantiate();
	newBullet.position = position;
	newBullet.look_at(Global.player.position);
	newBullet.direction = (Global.player.global_position - position).normalized();
	newBullet.body_target = "player";
	newBullet.speed = bullet_speed;
	newBullet.damage = enemy_damage;
	level.add_child(newBullet);
	
func explode():
	Global.killstreak = Global.killstreak + 1;
	Global.shakeCamera(150);
	for target in $SpaceArea.get_overlapping_bodies():
		if target.is_in_group("player") || target.is_in_group("enemies"):
			target.damage(explosion_damage);
			
func _on_damage_timer_timeout():
	can_take_damage = true;

func _on_shoot_delay_timer_timeout():
	if not is_dead:
		can_shoot = true;


func _on_space_area_area_entered(area):
	if area.is_in_group("bullets") && is_dead:
		area.set_on_fire();
