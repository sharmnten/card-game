extends Node2D

@onready var body_frames = {
	"light": preload("res://Sprites/SpriteFrames/Base/light_base.tres"),
	"medium": preload("res://Sprites/SpriteFrames/Base/medium_base.tres"),
	"dark": preload("res://Sprites/SpriteFrames/Base/dark_base.tres")
}
@onready var bottom_frames={
	"blue": preload("res://Sprites/SpriteFrames/Bottom/blue_bottom.tres"),
	"brown": preload("res://Sprites/SpriteFrames/Bottom/brown_bottom.tres")
}
@onready var eyes_frames={
	"blue": preload("res://Sprites/SpriteFrames/Eyes/blue_eyes.tres"),
	"brown": preload("res://Sprites/SpriteFrames/Eyes/brown_eyes.tres"),
	"green": preload("res://Sprites/SpriteFrames/Eyes/green_eyes.tres")
}
@onready var hair_frames={
	"cop": preload("res://Sprites/SpriteFrames/Hair/cop_hair.tres"),
	"medium_brown":preload("res://Sprites/SpriteFrames/Hair/medium_brown_hair.tres"),
	"medium_red":preload("res://Sprites/SpriteFrames/Hair/medium_red_hair.tres"),
	"medium_yellow":preload("res://Sprites/SpriteFrames/Hair/medium_yellow_hair.tres"),
	"short_brown":preload("res://Sprites/SpriteFrames/Hair/short_brown_hair.tres"),
	"short_red":preload("res://Sprites/SpriteFrames/Hair/short_red_hair.tres"),
	"short_yellow":preload("res://Sprites/SpriteFrames/Hair/short_yellow_hair.tres")
}
@onready var top_frames={
	"blue":preload("res://Sprites/SpriteFrames/Top/blue_top.tres"),
	"green":preload("res://Sprites/SpriteFrames/Top/green_top.tres"),
	"pink":preload("res://Sprites/SpriteFrames/Top/pink_top.tres"),
	"red":preload("res://Sprites/SpriteFrames/Top/red_top.tres"),
	"yellow":preload("res://Sprites/SpriteFrames/Top/yellow_top.tres")
}

#TODO: Change this when game is more complete.
@onready var game_scene=preload("res://Scenes/game.tscn")

#set up all body components
@onready var base=get_node("CharacterBody2D/Base")
@onready var bottom=get_node("CharacterBody2D/Bottom")
@onready var eyes=get_node("CharacterBody2D/Eyes")
@onready var hair=get_node("CharacterBody2D/Hair")
@onready var top=get_node("CharacterBody2D/Top")
@onready var shadow=get_node("CharacterBody2D/Shadow")

#define current body frames
@onready var base_order=["light","medium","dark"]
@onready var current_base_frame=0

#define current bottom frames
@onready var bottom_order=["blue","brown"]
@onready var current_bottom_frame=0

#define current eyes frames
@onready var eyes_order=["blue","brown","green"]
@onready var current_eyes_frame=0
#define current hair frames
@onready var hair_order=["medium_brown","medium_red","medium_yellow","short_brown","short_red","short_yellow"]
@onready var current_hair_frame=0
#define current top frames
@onready var top_order=["blue","green","pink","red","yellow"]
@onready var current_top_frame=0


func _ready()->void:
	update_character("idle_front")
	
	
func update_character(currentAnim):
	var anim=currentAnim
	base.sprite_frames=body_frames[base_order[current_base_frame]]
	bottom.sprite_frames=bottom_frames[bottom_order[current_bottom_frame]]
	eyes.sprite_frames=eyes_frames[eyes_order[current_eyes_frame]]
	top.sprite_frames=top_frames[top_order[current_top_frame]]
	hair.sprite_frames=hair_frames[hair_order[current_hair_frame]]
	#reset anims
	base.frame=0
	bottom.frame=0
	eyes.frame=0
	hair.frame=0
	top.frame=0
	#save the game
	GameState.set_character(current_base_frame, current_bottom_frame, current_eyes_frame, current_hair_frame, current_top_frame)
	print(GameState.get_character())
	#play animations
	
	
	base.play(anim)
	bottom.play(anim)
	eyes.play(anim)
	hair.play(anim)
	top.play(anim)

func _on_base_right_pressed() -> void:
	current_base_frame = (current_base_frame + 1) % base_order.size()
	update_character("idle_front")

func _on_base_left_pressed() -> void:
	current_base_frame = (current_base_frame - 1 + base_order.size()) % base_order.size()
	update_character("idle_front")


func _on_bottom_right_pressed() -> void:
	current_bottom_frame=(current_bottom_frame +1) % bottom_order.size()
	update_character("idle_front")


func _on_bottom_left_pressed() -> void:
	current_bottom_frame = (current_bottom_frame - 1 + bottom_order.size()) % bottom_order.size()
	update_character("idle_front")


func _on_eyes_right_pressed() -> void:
	current_eyes_frame=(current_eyes_frame +1) % eyes_order.size()
	update_character("idle_front")


func _on_eyes_left_pressed() -> void:
	current_eyes_frame = (current_eyes_frame - 1 + eyes_order.size()) % eyes_order.size()
	update_character("idle_front")


func _on_hair_right_pressed() -> void:
	current_hair_frame=(current_hair_frame +1) % hair_order.size()
	update_character("idle_front")


func _on_hair_left_pressed() -> void:
	current_hair_frame = (current_hair_frame - 1 + hair_order.size()) % hair_order.size()
	update_character("idle_front")


func _on_top_right_pressed() -> void:
	current_top_frame=(current_top_frame +1) % top_order.size()
	update_character("idle_front")


func _on_top_left_pressed() -> void:
	current_top_frame = (current_top_frame - 1 + top_order.size()) % top_order.size()
	update_character("idle_front")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)
