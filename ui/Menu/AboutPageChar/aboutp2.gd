extends CharacterBody2D
#p2222222
@onready var playerAni = $AnimatedSprite2D

var dir = Vector2.ZERO
var speed = 700

#数字
var number=1
#哪一方的
var side=2

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
	
var acceleration_time = 0.0
var max_acceleration_time = 0.2 # 最大加速时间

func _physics_process(delta):
		
	var input_dir = Input.get_vector("p2_left", "p2_right", "p2_up", "p2_down", false)
	var direction = Vector2(input_dir.x, input_dir.y)
	update_animation(input_dir)

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
