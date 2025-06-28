extends Node

# 全局变量
var current_scene = null
var is_changing_scene = false

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

# 场景切换函数
func change_scene(path: String):
	if is_changing_scene:
		return
	
	is_changing_scene = true
	print("正在切换场景到: ", path)
	
	# 释放当前场景
	call_deferred("_deferred_change_scene", path)

func _deferred_change_scene(path: String):
	# 释放当前场景
	if current_scene:
		current_scene.free()
	
	# 加载新场景
	var new_scene = ResourceLoader.load(path)
	if new_scene == null:
		print("错误: 无法加载场景 ", path)
		is_changing_scene = false
		return
	
	# 实例化新场景
	current_scene = new_scene.instantiate()
	
	# 添加到场景树
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
	is_changing_scene = false
	print("场景切换完成: ", path)

# 重新开始当前场景
func restart_current_scene():
	if current_scene:
		var scene_path = current_scene.scene_file_path
		change_scene(scene_path)

# 退出游戏
func quit_game():
	print("退出游戏")
	get_tree().quit()

# 暂停/恢复游戏
func toggle_pause():
	get_tree().paused = !get_tree().paused
	print("游戏暂停状态: ", get_tree().paused)

# 设置游戏暂停状态
func set_pause(paused: bool):
	get_tree().paused = paused
	print("设置游戏暂停: ", paused)

# 获取当前场景路径
func get_current_scene_path() -> String:
	if current_scene:
		return current_scene.scene_file_path
	return ""

# 预加载场景（可选功能）
func preload_scene(path: String):
	var scene = ResourceLoader.load(path)
	if scene:
		print("场景预加载成功: ", path)
		return scene
	else:
		print("场景预加载失败: ", path)
		return null
