extends Node2D

func _ready():
	update();
	
func update():
	if Global.background:
		%Parallax1.visible = true;
		%Parallax2.visible = true;
		%Parallax3.visible = true;
		
	else:
		%Parallax1.visible = false;
		%Parallax2.visible = false;
		%Parallax3.visible = false;
		
func follow_mouse(delta):
	offset(get_global_mouse_position().normalized(), 1200, delta);
	
func offset(direction, speed, delta):
	%Parallax1.scroll_offset = direction * speed * delta;
