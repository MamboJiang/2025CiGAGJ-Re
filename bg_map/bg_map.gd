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

func _input(event):
	# 检测p1change按键（1键）
	if Input.is_action_just_pressed("p1change"):
		match (p1selected):
			1:
				if p1hero.get_collider()!=null&& p1hero.get_collider().side==1:
					p1selected=p1hero.get_collider().number
			2:
				if p1knife.get_collider()!=null&& p1knife.get_collider().side==1:
					p1selected=p1knife.get_collider().number
			3:
				if p1pan.get_collider()!=null&& p1pan.get_collider().side==1:
					p1selected=p1pan.get_collider().number
			4:
				if p1milk.get_collider()!=null&& p1milk.get_collider().side==1:
					p1selected=p1milk.get_collider().number
		print("P1 切换到: ", p1selected)
	
	# 检测p2change按键（2键）
	if Input.is_action_just_pressed("p2change"):
		match (p2selected):
			1:
				if p2hero.get_collider()!=null&& p2hero.get_collider().side==2:
					p2selected=p2hero.get_collider().number
			2:
				if p2knife.get_collider()!=null&& p2knife.get_collider().side==2:
					p2selected=p2knife.get_collider().number
			3:
				if p2pan.get_collider()!=null&& p2pan.get_collider().side==2:
					p2selected=p2pan.get_collider().number
			4:
				if p2milk.get_collider()!=null&& p2milk.get_collider().side==2:
					p2selected=p2milk.get_collider().number
				
		print("P2 切换到: ", p2selected)
