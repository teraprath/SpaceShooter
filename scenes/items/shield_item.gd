extends ItemParent

@onready var shield : PackedScene = preload("res://scenes/objects/shield.tscn");

func collect():
	if Global.player.has_node("Shield"):
		Global.renew_shield += 1;
		Global.alert("subtitle", "+1 Shield Upgrade");
	else:
		var item = shield.instantiate();
		Global.player.call_deferred("add_child", item);
		Global.alert("subtitle", "Shield avtivated");
	Global.player_score += 100;
	queue_free();
