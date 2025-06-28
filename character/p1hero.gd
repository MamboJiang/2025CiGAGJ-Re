extends CharacterBody2D
#p1111111
@onready var playerAni = $AnimatedSprite2D

var dir = Vector2.ZERO
var speed = 700

#生命
var health = 100

#数字
var number=1
#哪一方的
var side=1

#死亡状态
var is_dead = false
var death_animation_played = false


func _physics_process(delta):
	# 检查角色是否死亡
	check_death()
	
	# 如果角色已死亡，不处理移动
	if is_dead:
		return
	
	# 只有当父节点的p1selected为1时才检测输入
	if get_parent().p1selected != 1:
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

func get_attacked():
	health = health - 20
	# 受到攻击后检查死亡状态
	check_death()

func check_death():
	# 如果生命值小于等于0且还没有死亡
	if health <= 0 and not is_dead:
		is_dead = true
		play_death_animation()
		print("角色死亡")

func play_death_animation():
	# 如果死亡动画还没播放过
	if not death_animation_played:
		death_animation_played = true
		# 播放死亡动画（假设动画名为"death"）
		playerAni.play("death")
		# 连接动画完成信号，确保动画只播放一次
		if not playerAni.animation_finished.is_connected(_on_death_animation_finished):
			playerAni.animation_finished.connect(_on_death_animation_finished)

func _on_death_animation_finished():
	# 死亡动画播放完成后，停止在最后一帧
	if playerAni.animation == "death":
		playerAni.stop()
		# 断开信号连接，避免重复触发
		if playerAni.animation_finished.is_connected(_on_death_animation_finished):
			playerAni.animation_finished.disconnect(_on_death_animation_finished)

func revive(restore_health: int = 100):
	# 复活角色
	if is_dead:
		# 重置死亡状态
		is_dead = false
		death_animation_played = false
		
		# 恢复生命值
		health = restore_health
		
		# 播放待机动画
		playerAni.play("idle")
		
		# 打印复活信息
		print("角色复活，生命值恢复到: ", health)
	else:
		print("角色还活着，无需复活")
