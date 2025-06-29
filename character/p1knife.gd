extends CharacterBody2D
#p1111111knife
@onready var playerAni = $AnimatedSprite2D
@onready var cd_timer: Timer = $cd_timer
@onready var cd_ui: RichTextLabel = $cd_ui
@onready var health_bar: TextureProgressBar = $health_bar
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shield_ui: Sprite2D = $shield_ui


#是否有护盾
var is_shield=false

var dir = Vector2.ZERO
var speed = 700

#生命
var health = 100

#数字
var number=2
#哪一方的
var side=1

# 死亡状态管理
var is_dead = false
var death_animation_played = false

var is_attack=false

# 方向状态管理
var last_direction = Vector2.RIGHT
var facing_direction = "right"  # "left" 或 "right"

func update_health():
	health_bar.value=health

func _ready() -> void:
	shield_ui.hide()
	update_health()
	
var acceleration_time = 0.0
var max_acceleration_time = 0.2 # 最大加速时间

func _physics_process(delta):

	# 检查死亡状态
	check_death()
	# 如果角色死亡，停止移动
	if is_dead:
		return
		
	check_attack()
	if is_attack:
		return
	
	#显示cd
	cd_ui.text="%.2f" % cd_timer.time_left

	# 只有当父节点的p1selected为2时才检测输入
	if get_parent().p1selected != 2:
		return
		
	var input_dir = Input.get_vector("p1_left", "p1_right", "p1_up", "p1_down", false)
	var direction = Vector2(input_dir.x, input_dir.y)
	update_animation(input_dir)
	#攻击
	if Input.is_action_pressed("p1_act"):
		attack()

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
	
	check_death()

func update_animation(dir):
	# 更新朝向状态
	if dir.x > 0:
		facing_direction = "right"
		last_direction = Vector2.RIGHT
	elif dir.x < 0:
		facing_direction = "left"
		last_direction = Vector2.LEFT
	
	# 根据移动方向播放对应动画
	if dir.length() > 0:
		# 有移动时播放行走动画
		if abs(dir.x) > abs(dir.y):
			# 水平移动优先
			if dir.x > 0:
				playerAni.play("walk_right")
				playerAni.flip_h = true   # 向右时翻转
			else:
				playerAni.play("walk_right")  # 使用同一个动画
				playerAni.flip_h = false  # 向左时不翻转
		else:
			# 垂直移动时保持当前朝向
			playerAni.flip_h = (facing_direction == "right")
			if dir.y > 0:
				playerAni.play("walk_down")
			else:
				playerAni.play("walk_up")
	else:
		# idle时保持最后的朝向
		playerAni.flip_h = (facing_direction == "right")
		playerAni.play("idle")
		

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D
func get_collider():
	if shape_cast_2d.is_colliding():
		return shape_cast_2d.get_collider(0)
	else:
		return null

#技能
func attack():
	if get_collider()!=null && not get_collider() is TileMap:
		if cd_timer.is_stopped():
			cd_timer.start()
			#延迟半秒扣血
			await get_tree().create_timer(0.5).timeout
			if get_collider() != null && not get_collider() is TileMap:  # 再次检查以防目标在这半秒内消失
				get_collider().get_attacked()
			print("attacked")
			Globals.play_sfx(preload("res://asset/sound/hurt.mp3"))
			
func check_attack():
	# 如果角色已死亡，不播放攻击动画
	if is_dead:
		is_attack=0
		return
		
	if cd_timer.time_left>2:
		# 攻击动画也需要考虑方向
		playerAni.flip_h = (facing_direction == "right")
		playerAni.play("attack")
		is_attack=1
	else:
		is_attack=0
	

func get_attacked():
	if is_shield:
		shield_ui.hide()
		is_shield=false
		return
	health = health - 20
	#血条更新
	update_health()
	# 受到攻击后检查是否死亡
	check_death()

# 检查角色是否死亡
func check_death():
	if health <= 0 and not is_dead:
		is_dead = true
		play_death_animation()
		Globals.play_sfx(preload("res://asset/sound/deadwav.wav"))
		print("P1 Knife角色死亡")

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
		print("P1 Knife死亡动画播放完成")

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
	update_health()

# 返回角色是否死亡的状态
func is_character_dead() -> bool:
	return is_dead
	
func add_shield():
	is_shield=true
	shield_ui.show()
	await get_tree().create_timer(3).timeout
	is_shield=false
	shield_ui.hide()
	
