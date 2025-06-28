extends CharacterBody2D
#p1111111knife
@onready var playerAni = $AnimatedSprite2D

var dir = Vector2.ZERO
var speed = 700

#数字
var number=3
#哪一方的
var side=1

func _physics_process(delta):
	# 只有当父节点的p1selected为2时才检测输入
	if get_parent().p1selected != 3:
		return
	
	# 获取输入方向
	dir = Vector2.ZERO
	
	# 检测p1按键输入
	if Input.is_action_pressed("p1_right"):
		dir.x += 1
	if Input.is_action_pressed("p1_left"):
		dir.x -= 1
	if Input.is_action_pressed("p1_down"):
		dir.y += 1
	if Input.is_action_pressed("p1_up"):
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

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D
func get_collider():
	if shape_cast_2d.is_colliding():
		return shape_cast_2d.get_collider(0)
	else:
		return null
