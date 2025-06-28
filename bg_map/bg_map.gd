extends Node2D

@onready var tilemap = $TileMap

#hero=1, knife=2, pan=3, milk=4
@onready var p1selected = 1
@onready var p2selected = 1

func _input(event):
	# 检测p1change按键（1键）
	if Input.is_action_just_pressed("p1change"):
		# 轮次切换p1selected的值：1->2->3->4->1
		p1selected += 1
		if p1selected > 4:
			p1selected = 1
		print("P1 切换到: ", p1selected)
	
	# 检测p2change按键（2键）
	if Input.is_action_just_pressed("p2change"):
		# 轮次切换p2selected的值：1->2->3->4->1
		p2selected += 1
		if p2selected > 4:
			p2selected = 1
		print("P2 切换到: ", p2selected)
