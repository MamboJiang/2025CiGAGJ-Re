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

var p1_object
var p2_object

func _input(event):
	# 检测p1change按键（1键）
	if Input.is_action_just_pressed("p1change"):
		if not p1_change_timer.is_stopped():
			return
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
		if p1selected!=1:
			p1hero.appear(p1_object.position)
			p1selected=1
	
	# 检测p2change按键（2键）
	if Input.is_action_just_pressed("p2change"):
		if not p2_change_timer.is_stopped():
			return
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
		if p2selected!=1:
			p2hero.appear(p2_object.position)
			p2selected=1
