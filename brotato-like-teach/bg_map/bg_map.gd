extends Node2D

@onready var tilemap = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	random_tile()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func random_tile():
	tilemap.clear_layer(1)
	var bg1_cells = tilemap.get_used_cells(0)
	var ran = RandomNumberGenerator.new()
	for cell_pos in bg1_cells:
		var num = ran.randi_range(0, 100)
		if num <= 5:
			tilemap.set_cell(1, cell_pos, 0, Vector2i(18, 1))
			
#	for cell_pos in bg1_cells:
#		var num = ran.randi_range(0, 100)
#		if num <= 1:
#			tilemap.set_cell(1, cell_pos, 0, Vector2i(9, 3))		
#	for cell_pos in bg1_cells:
#		var num = ran.randi_range(0, 100)
#		if num <= 1:
#			tilemap.set_cell(1, cell_pos, 0, Vector2i(9, 4))		
	for cell_pos in bg1_cells:
		var num = ran.randi_range(0, 100)
		if num <= 0:
			tilemap.set_cell(1, cell_pos, 0, Vector2i(6, 2))
	pass


func _on_button_pressed():
	random_tile()
	pass # Replace with function body.


func _on_game_ui_round_end():
	get_tree().paused = true
	$scene_update.init()
	pass # Replace with function body.


func _on_scene_update_continue_game():
	get_tree().paused = false
	$scene_update.hide()
	$player.now_hp = $player.max_hp
	$game_ui.init_round()
	var drop_items = get_tree().get_nodes_in_group("drop_item")
	for drop_item in drop_items:
		if drop_item.get_collision_layer_value(5):
			self.remove_child(drop_item)
			drop_item.queue_free()
	$now_enemies.delete_enemies()
	pass # Replace with function body.
