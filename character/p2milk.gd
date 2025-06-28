extends CharacterBody2D
#p222222milk
@onready var playerAni = $AnimatedSprite2D

var dir = Vector2.ZERO
var speed = 700

func _physics_process(delta):
	# 只有当父节点的p1selected为1时才检测输入
	if get_parent().p2selected != 4:
		return
	
	# 获取输入方向
	dir = Vector2.ZERO
	
	# 检测p1按键输入
	if Input.is_action_pressed("p2_right"):
		dir.x += 1
	if Input.is_action_pressed("p2_left"):
		dir.x -= 1
	if Input.is_action_pressed("p2_down"):
		dir.y += 1
	if Input.is_action_pressed("p2_up"):
		dir.y -= 1
	
	# 标准化方向向量，防止对角线移动过快
	if dir.length() > 0:
		dir = dir.normalized()
	
	# 设置速度
	velocity = dir * speed
	
	# 应用移动
	move_and_slide()
	
	# 处理动画
	update_animation()

func update_animation():
	# 根据移动方向播放对应动画
	if dir.length() > 0:
		# 有移动时播放行走动画
		if abs(dir.x) > abs(dir.y):
			# 水平移动优先
			if dir.x > 0:
				playerAni.play("walk_right")
			else:
				playerAni.play("walk_left")
		else:
			# 垂直移动
			if dir.y > 0:
				playerAni.play("walk_down")
			else:
				playerAni.play("walk_up")
	else:
		# 没有移动时播放待机动画
		playerAni.play("idle")
