extends Node

# 动效管理
var animation_scene = preload("res://animations/animations.tscn")
var animation_scene_obj = null

# 掉落物管理
var drop_item_scene = preload("res://drop_items/drop_items.tscn")
var drop_item_scene_obj = null

var duplicate_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	init_duplicate_node()
	animation_scene_obj = animation_scene.instantiate()
	add_child(animation_scene_obj)
	drop_item_scene_obj = drop_item_scene.instantiate()
	add_child(drop_item_scene_obj)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# 初始化拷贝对象容器
func init_duplicate_node():
	if duplicate_node != null:
		duplicate_node.queue_free()
	var node2d = Node2D.new()
	node2d.name = "duplicate_node"
	get_window().add_child.call_deferred(node2d)
	duplicate_node = node2d
