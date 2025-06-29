extends CharacterBody2D
#p1111111knife
@onready var playerAni = $AnimatedSprite2D
@onready var health_bar: TextureProgressBar = $health_bar
@onready var cd_timer: Timer = $cd_timer
@onready var cd_ui: RichTextLabel = $cd_ui
@onready var bg_map: Node2D = $".."

var dir = Vector2.ZERO
var speed = 700

#是否有护盾
var is_shield=false

#生命
var health = 100

#数字
var number=3
#哪一方的
var side=1

# 死亡状态管理
var is_dead = false
var death_animation_played = false

func update_health():
	health_bar.value=health

func _ready() -> void:
	update_health()



var acceleration_time = 0.0
var max_acceleration_time = 0.2 # 最大加速时间

func _physics_process(delta):

	# 检查死亡状态
	check_death()
	
	# 如果角色死亡，停止移动
	if is_dead:
		return
		
	#显示cd
	cd_ui.text="%.2f" % cd_timer.time_left
	
	# 只有当父节点的p1selected为3时才检测输入
	if get_parent().p1selected != 3:
		return
		
	var input_dir = Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down", false)
	var direction = Vector2(input_dir.x, input_dir.y)
	update_animation(input_dir)
	#攻击
	if Input.is_action_pressed("p1_act"):
		shield()
	if direction:
		direction = direction.normalized()
		acceleration_time = min(acceleration_time + delta, max_acceleration_time)
		var acceleration_factor = sin((acceleration_time / max_acceleration_time) * PI / 2)
		velocity.x = direction.x * speed * acceleration_factor
		velocity.y = direction.y * speed * acceleration_factor
		
	else:
		#没有输入的时候逐渐减速
		acceleration_time = max(acceleration_time - delta, 0)
		var deceleration_factor = cos((acceleration_time / max_acceleration_time) * PI / 2)
		velocity.x = move_toward(velocity.x, 0, speed * deceleration_factor * delta * 10)
		velocity.y = move_toward(velocity.y, 0, speed * deceleration_factor * delta * 10)
	
	# 应用移动
	move_and_slide()
	
	# 处理动画
	update_animation(input_dir)

func update_animation(dir):
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
	if is_shield:
		is_shield=false
		return
	health = health - 20
	update_health()
	# 受到攻击后检查是否死亡
	check_death()

# 检查角色是否死亡
func check_death():
	if health <= 0 and not is_dead:
		is_dead = true
		play_death_animation()
		print("P1 Pan角色死亡")

# 播放死亡动画
func play_death_animation():
	if not death_animation_played:
		death_animation_played = true
		playerAni.play("death")
		# 连接动画完成信号
		if not playerAni.animation_finished.is_connected(_on_death_animation_finished):
			playerAni.animation_finished.connect(_on_death_animation_finished)

# 死亡动画播放完成后的处理
func _on_death_animation_finished():
	if is_dead and playerAni.animation == "death":
		# 设置为死亡动画的最后一帧并变灰
		playerAni.frame = playerAni.sprite_frames.get_frame_count("death") - 1
		playerAni.modulate = Color(0.5, 0.5, 0.5, 1.0)  # 变灰效果
		playerAni.stop()
		playerAni.frame = playerAni.sprite_frames.get_frame_count("death") - 1
		print("P1 Pan死亡动画播放完成")

# 复活函数
func revive(restore_health: int = 100):
	# 复活角色
	if is_dead:
		# 重置死亡状态
		is_dead = false
		death_animation_played = false
		
		# 恢复生命值
		health = restore_health
		
		# 恢复正常颜色
		playerAni.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
		# 播放待机动画
		playerAni.play("idle")
		
		# 打印复活信息
		print("角色复活，生命值恢复到: ", health)
	else:
		print("角色还活着，无需复活")

# 返回角色是否死亡的状态
func is_character_dead() -> bool:
	return is_dead

#技能
func shield():
	if cd_timer.is_stopped():
		cd_timer.start()
		#延迟半秒加护盾
		await get_tree().create_timer(0.5).timeout
		bg_map.p1_shield()
		print("defended")
	
func add_shield():
	is_shield=true
	await get_tree().create_timer(3).timeout
	is_shield=false
