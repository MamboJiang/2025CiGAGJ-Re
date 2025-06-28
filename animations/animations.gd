extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_all_animation_finished():
	self.queue_free()
	pass # Replace with function body.

func run_animation(options):
	if !options.has("box"):
		options.box = Main.duplicate_node
	var all_ani = self.duplicate()
	options.box.add_child(all_ani)
	all_ani.show()
	all_ani.scale = options.scale if options.has("scale") else Vector2(1,1)
	all_ani.position = options.position
	all_ani.get_node("all_animations").play(options.ani_name)
	pass
