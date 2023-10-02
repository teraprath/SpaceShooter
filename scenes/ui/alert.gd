extends VBoxContainer

var current_title = "";
var current_subtitle = "";

func _ready():
	Global.connect("subtitle", on_subtitle);
	Global.connect("title", on_title);
	
func on_title():
	$Title.text = Global.titleList.pop_front();
	current_title = $Title.text;
	$TitleTimer.start();

func _on_title_timer_timeout():
	if current_title == $Title.text:
		current_title = "";
		$Title.text = current_title;
	
func on_subtitle():
	$Subtitle.text = Global.subtitleList.pop_front();
	current_subtitle = $Subtitle.text;
	$SubtitleTimer.start();

func _on_subtitle_timer_timeout():
	if current_subtitle == $Subtitle.text:
		current_subtitle = "";
		$Subtitle.text = current_subtitle;
