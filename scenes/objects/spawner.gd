extends Node2D

var enemies : Array[PackedScene] = [];

@onready var drone1 : PackedScene = preload("res://scenes/enemies/drone_01.tscn");
@onready var drone2 : PackedScene = preload("res://scenes/enemies/drone_02.tscn");
@onready var drone3 : PackedScene = preload("res://scenes/enemies/drone_03.tscn");

func _ready():
	reset();

func reset():
	enemies = [];
	enemies.push_back(drone1);

func _on_enemy_spawn_timer_timeout():
	
	if Global.entity_container.get_child_count() < Global.max_entities && Global.player.is_alive:
		spawn_enemy();
		update_level();
	
func randomPosition() -> Marker2D:
	return $Positions.get_children().pick_random();
	
func random() -> PackedScene:
	return enemies.pick_random();
	
func spawn_enemy():
	var pos : Marker2D = randomPosition();
	var instance : Node = random().instantiate();
	instance.global_position = pos.global_position;
	Global.entity_container.add_child(instance);

func update_level():
	if enemies.has(drone2) == false && Global.player_score > 500:
		enemies.push_back(drone2);
	elif $Timer/EnemySpawnTimer.wait_time == 4 && Global.player_score > 1000:
		$Timer/EnemySpawnTimer.wait_time = 3.5;
	elif enemies.has(drone3) == false && Global.player_score > 2000:
		enemies.push_back(drone3);
	elif $Timer/EnemySpawnTimer.wait_time == 3.5 && Global.player_score > 4000:
		$Timer/EnemySpawnTimer.wait_time = 3;
	elif $Timer/EnemySpawnTimer.wait_time == 3 && Global.player_score > 8000:
		$Timer/EnemySpawnTimer.wait_time = 2.5;
	elif $Timer/EnemySpawnTimer.wait_time == 2.5 && Global.player_score > 12000:
		$Timer/EnemySpawnTimer.wait_time = 2;
