extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.play_bgm(preload("res://asset/sound/start.mp3"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("p1change") or Input.is_action_pressed("p2change"):
		Globals.go_to_world("res://bg_map/bg_map.tscn")
	pass


func _on_start_button_pressed() -> void:
	Globals.go_to_world("res://bg_map/bg_map.tscn")



func _on_about_button_pressed() -> void:
	Globals.go_to_world("res://ui/Menu/about_page.tscn")



func _on_quit_button_pressed() -> void:
	get_tree().quit()
