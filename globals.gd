#Global是控制整个游戏框架的脚本，包括背景音乐，页面和关卡的切换

extends Node

@onready var animation_player = $AnimationPlayer
@onready var bgm_player = $BGM
@onready var sfx_player = $SFX

#在各种地方都可以通过Globals.reload_world()来重置世界
func reload_world():
	animation_player.play_backwards("fade-in")
	await animation_player.animation_finished
	get_tree().reload_current_scene()
	animation_player.play("fade-in")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_esc") and get_tree().current_scene.scene_file_path != "res://ui/Menu/start_menu.tscn":
		back_to_title()

func _animate_transition_to(path):
	animation_player.play_backwards("fade-in")
	await animation_player.animation_finished
	if path:
		get_tree().change_scene_to_file(path)
	else:
		get_tree().reload_current_scene()
	
	animation_player.play("fade-in")

func play_fade_out():
	animation_player.play_backwards("fade-in")

func play_fade_in():
	animation_player.play("fade-in")

func start_game():
	go_to_world("res://ui/Menu/start_menu.tscn")

#到时候可以写保留什么东西等等
func go_to_world(path):
	_animate_transition_to(path)
	
func back_to_title():
	_animate_transition_to("res://ui/Menu/start_menu.tscn")

# 音效播放功能
func play_sfx(audio_stream: AudioStream, volume_db: float = 0.0):
	if sfx_player and audio_stream:
		sfx_player.stream = audio_stream
		sfx_player.volume_db = volume_db
		sfx_player.play()

func play_bgm(audio_stream: AudioStream, volume_db: float = 0.0, loop: bool = true):
	if bgm_player and audio_stream:
		bgm_player.stream = audio_stream
		bgm_player.volume_db = volume_db
		if audio_stream is AudioStreamOggVorbis:
			audio_stream.loop = loop
		elif audio_stream is AudioStreamMP3:
			audio_stream.loop = loop
		bgm_player.play()

func stop_bgm():
	if bgm_player:
		bgm_player.stop()

func stop_sfx():
	if sfx_player:
		sfx_player.stop()

func set_bgm_volume(volume_db: float):
	if bgm_player:
		bgm_player.volume_db = volume_db

func set_sfx_volume(volume_db: float):
	if sfx_player:
		sfx_player.volume_db = volume_db
