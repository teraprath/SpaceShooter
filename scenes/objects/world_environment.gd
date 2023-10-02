extends WorldEnvironment

func _ready():
	updateGraphics();
	
func updateGraphics():
	if Global.graphics == "High":
		self.environment.background_mode = Environment.BG_CANVAS;
		self.environment.glow_intensity = 0.5;
		self.environment.glow_strength = 1
		self.environment.glow_bloom = 0.5;
		self.environment.glow_enabled = true;
	elif Global.graphics == "Medium":
		self.environment.background_mode = Environment.BG_CANVAS;
		self.environment.glow_intensity = 0.4;
		self.environment.glow_strength = 0.8;
		self.environment.glow_bloom = 0.4;
		self.environment.glow_enabled = true;
	elif Global.graphics == "Low":
		self.environment.background_mode = Environment.BG_CLEAR_COLOR;
		self.environment.glow_enabled = true;
