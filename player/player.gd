extends Player

@onready var playerAni = $playerAni

var dir = Vector2.ZERO
var flip = false
var canMove = true
var stop = false

var level_add_num = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	init_attr()
	choosePlayer("player1")
	pass # Replace with function body.

func init_attr():
	speed = 600
	now_hp = 10
	max_hp = 10
	max_exp = 5
	now_exp = 0
	level = 1
	gold = 0
	pass

func choosePlayer(type):
	var player_path = "res://player/assets/"
	
	playerAni.sprite_frames.clear_all()
	
	var sprite_frame_custom = SpriteFrames.new()
#	sprite_frame_custom.add_animation("default")
#	sprite_frame_custom.set_animation_loop("default", true)
	var texture_size = Vector2(960, 240)
	var sprite_size = Vector2(240, 240)
	var full_texture: Texture = load(player_path + type + "/" + type + "-sheet.png")
	
	var num_columns = int(texture_size.x / sprite_size.x)
	var num_row = int(texture_size.y / sprite_size.y)
	
	for x in range(num_columns):
		for y in range(num_row):
			var frame = AtlasTexture.new()
			frame.atlas = full_texture
			frame.region = Rect2(Vector2(x, y) * sprite_size, sprite_size)
			sprite_frame_custom.add_frame("default", frame)
	
	playerAni.sprite_frames = sprite_frame_custom
	
	playerAni.play("default")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var self_pos = position
	
	if mouse_pos.x >= self_pos.x:
		flip = false
	else:
		flip = true
		
	playerAni.flip_h = flip
	
	dir = (mouse_pos - self_pos).normalized()
	
	if canMove and !stop:
		velocity = dir * speed
		move_and_slide()
	pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		canMove = false
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.is_pressed():
		canMove = true
	pass


func _on_stop_mouse_entered():
	stop = true
	pass # Replace with function body.


func _on_stop_mouse_exited():
	stop = false
	pass # Replace with function body.


func _on_drop_item_area_body_entered(body):
	if body.is_in_group('drop_item'):
		self.gold += (1 + self.gold_get)
		self.now_exp += (1 + self.exp_get)
		if self.now_exp >= self.max_exp:
			self.level += 1
			self.now_exp = 0
			self.level_add_num += 1
			self.max_exp *= 2
		body.canMoving = true
	pass # Replace with function body.


func _on_stop_body_entered(body):
	if body.is_in_group("enemy"):
		self.now_hp -= 1
	if body.is_in_group('drop_item'):
		body.queue_free()
	pass # Replace with function body.
