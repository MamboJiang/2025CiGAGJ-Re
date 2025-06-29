extends Node2D

@onready var tilemap = $TileMap

#hero=1, knife=2, pan=3, milk=4
@onready var p1selected = 1
@onready var p2selected = 1

@onready var p1hero: CharacterBody2D = $p1hero
@onready var p2hero: CharacterBody2D = $p2hero
@onready var p1knife: CharacterBody2D = $p1knife
@onready var p2knife: CharacterBody2D = $p2knife
@onready var p2pan: CharacterBody2D = $p2pan
@onready var p1pan: CharacterBody2D = $p1pan
@onready var p1milk: CharacterBody2D = $p1milk
@onready var p2milk: CharacterBody2D = $p2milk
@onready var p1_change_timer: Timer = $p1hero/change_timer
@onready var p2_change_timer: Timer = $p2hero/change_timer

@onready var p1_arrow: Sprite2D = $p1_arrow
@onready var p2_arrow: Sprite2D = $p2_arrow

var p1_object
var p2_object

# 游戏结束状态
var game_ended = false

func _ready():
	Globals.play_bgm(preload("res://asset/sound/main.mp3"))
	# 开始游戏结束检查
	pass

func _process(delta):
	# 检查游戏是否结束
	check_game_end()
	
	# 检查英雄附身的角色是否死亡，如果死亡则自动下车
	check_possessed_character_death()
	
	match (p1selected):
			1:
				p1_arrow.position=p1hero.position
				p1_arrow.position.y-=60
			2:
				p1_arrow.position=p1knife.position
				p1_arrow.position.y-=120
			3:
				p1_arrow.position=p1pan.position
				p1_arrow.position.y-=100
			4:
				p1_arrow.position=p1milk.position
				p1_arrow.position.y-=120
	match (p2selected):
			1:
				p2_arrow.position=p2hero.position
				p2_arrow.position.y-=60
			2:
				p2_arrow.position=p2knife.position
				p2_arrow.position.y-=120
			3:
				p2_arrow.position=p2pan.position
				p2_arrow.position.y-=100
			4:
				p2_arrow.position=p2milk.position
				p2_arrow.position.y-=120
				

func _input(event):
	# 检测p1change按键（1键）
	if Input.is_action_just_pressed("p1change"):
		if not p1_change_timer.is_stopped():
			return
		Globals.play_sfx(preload("res://asset/sound/knife.wav"))
		p1_change_timer.start()
		match (p1selected):
			1:
				if p1hero.get_collider()!=null && not p1hero.get_collider() is TileMap && p1hero.get_collider().side==1:
					p1selected=p1hero.get_collider().number
					p1_object=p1hero.get_collider()
			2:
				if p1knife.get_collider()!=null && not p1knife.get_collider() is TileMap && p1knife.get_collider().side==1:
					p1selected=p1knife.get_collider().number
					p1_object=p1knife.get_collider()
			3:
				if p1pan.get_collider()!=null && not p1pan.get_collider() is TileMap && p1pan.get_collider().side==1:
					p1selected=p1pan.get_collider().number
					p1_object=p1pan.get_collider()
			4:
				if p1milk.get_collider()!=null && not p1milk.get_collider() is TileMap && p1milk.get_collider().side==1:
					p1selected=p1milk.get_collider().number
					p1_object=p1milk.get_collider()
		if p1selected!=1:
			p1hero.disappear()
		print("P1 切换到: ", p1selected)
	if Input.is_action_just_pressed("p1_quit"):
		Globals.play_sfx(preload("res://asset/sound/knife.wav"))
		if p1selected!=1:
			p1hero.appear(p1_object.position)
			p1selected=1
	
	# 检测p2change按键（2键）
	if Input.is_action_just_pressed("p2change"):
		if not p2_change_timer.is_stopped():
			return
		Globals.play_sfx(preload("res://asset/sound/knife.wav"))
		p2_change_timer.start()
		match (p2selected):
			1:
				if p2hero.get_collider()!=null && not p2hero.get_collider() is TileMap && p2hero.get_collider().side==2:
					p2selected=p2hero.get_collider().number
					p2_object=p2hero.get_collider()
			2:
				if p2knife.get_collider()!=null && not p2knife.get_collider() is TileMap && p2knife.get_collider().side==2:
					p2selected=p2knife.get_collider().number
					p2_object=p2knife.get_collider()
			3:
				if p2pan.get_collider()!=null && not p2pan.get_collider() is TileMap && p2pan.get_collider().side==2:
					p2selected=p2pan.get_collider().number
					p2_object=p2pan.get_collider()
			4:
				if p2milk.get_collider()!=null && not p2milk.get_collider() is TileMap && p2milk.get_collider().side==2:
					p2selected=p2milk.get_collider().number
					p2_object=p2milk.get_collider()
		if p2selected!=1:
			p2hero.disappear()
		print("P2 切换到: ", p2selected)
	if Input.is_action_just_pressed("p2_quit"):
		Globals.play_sfx(preload("res://asset/sound/knife.wav"))
		if p2selected!=1:
			p2hero.appear(p2_object.position)
			p2selected=1
	
	# 调试功能：按等于键一键杀死所有工具角色
	if Input.is_action_just_pressed("ui_accept") or Input.is_key_pressed(KEY_EQUAL):
		kill_all_tools()
		print("调试：一键杀死所有工具角色")
			
func p1_shield():
	p1knife.add_shield()
	p1pan.add_shield()
	p1milk.add_shield()
	
func p2_shield():
	p2knife.add_shield()
	p2pan.add_shield()
	p2milk.add_shield()

# 检查游戏结束条件
func check_game_end():
	if game_ended:
		return
	
	# 检查P1方所有工具是否都死亡
	var p1_all_dead = p1knife.is_character_dead() and p1pan.is_character_dead() and p1milk.is_character_dead()
	
	# 检查P2方所有工具是否都死亡
	var p2_all_dead = p2knife.is_character_dead() and p2pan.is_character_dead() and p2milk.is_character_dead()
	
	if p1_all_dead and not p2_all_dead:
		# P2胜利
		game_ended = true
		print("P2胜利！")
		# TODO: 切换到P2胜利场景
		Globals.go_to_world("res://ui/Ending/p2winning.tscn")
		
	elif p2_all_dead and not p1_all_dead:
		# P1胜利
		game_ended = true
		print("P1胜利！")
		# TODO: 切换到P1胜利场景
		Globals.go_to_world("res://ui/Ending/p1winning.tscn")
		
	elif p1_all_dead and p2_all_dead:
		# 平局
		game_ended = true
		print("平局！")
		# TODO: 切换到平局场景
		# get_tree().change_scene_to_file("res://ui/victory/draw.tscn")

# 检查英雄附身的角色是否死亡，如果死亡则自动下车
func check_possessed_character_death():
	# 检查P1英雄附身的角色
	if p1selected != 1:
		var possessed_dead = false
		match p1selected:
			2: # 刀
				possessed_dead = p1knife.is_character_dead()
			3: # 平底锅
				possessed_dead = p1pan.is_character_dead()
			4: # 牛奶
				possessed_dead = p1milk.is_character_dead()
		
		if possessed_dead:
			# 自动让P1英雄下车
			p1hero.appear(p1_object.position)
			p1selected = 1
			print("P1英雄自动下车：附身角色已死亡")
	
	# 检查P2英雄附身的角色
	if p2selected != 1:
		var possessed_dead = false
		match p2selected:
			2: # 刀
				possessed_dead = p2knife.is_character_dead()
			3: # 平底锅
				possessed_dead = p2pan.is_character_dead()
			4: # 牛奶
				possessed_dead = p2milk.is_character_dead()
		
		if possessed_dead:
			# 自动让P2英雄下车
			p2hero.appear(p2_object.position)
			p2selected = 1
			print("P2英雄自动下车：附身角色已死亡")

# 调试功能：杀死所有工具角色
func kill_all_tools():
	# 对每个工具角色连续攻击5次确保死亡
	for i in range(5):
		p1knife.get_attacked()
		p1pan.get_attacked()
		p1milk.get_attacked()
		p2knife.get_attacked()
		p2pan.get_attacked()
		p2milk.get_attacked()
