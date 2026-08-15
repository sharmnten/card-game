extends CharacterBody2D

const SPEED := 300.0
const DIAG_SPEED := SPEED / sqrt(2.0)

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

func _ready()->void:
	
	$Base.sprite_frames=body_frames["dark"]
	
	$Bottom.sprite_frames=bottom_frames["brown"]
	
	$Eyes.sprite_frames=eyes_frames["blue"]
	
	$Hair.sprite_frames=hair_frames["short_red"]
	
	$Top.sprite_frames=top_frames["blue"]
	set_anim("idle_front")

func set_anim(anim)->void:
	$Base.play(anim)
	$Bottom.play(anim)
	$Eyes.play(anim)
	$Hair.play(anim)
	$Top.play(anim)
	$Shadow.play(anim)
func set_flip(status)->void:
	$Base.flip_h=status
	$Bottom.flip_h=status
	$Eyes.flip_h=status
	$Hair.flip_h=status
	$Top.flip_h=status
	$Shadow.flip_h=status
	


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	var v_direction := Input.get_axis("up", "down")

	if direction != 0 and v_direction != 0:
		velocity.x = direction * DIAG_SPEED
		velocity.y = v_direction * DIAG_SPEED
	elif v_direction != 0:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
		velocity.y = v_direction * SPEED
	elif direction != 0:
		velocity.x = direction * SPEED
		velocity.y = move_toward(velocity.y, 0.0, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
		velocity.y = move_toward(velocity.y, 0.0, SPEED)
		set_anim("idle_front")
	if v_direction ==1:
		set_anim("walk_front")
		set_flip(false)
	elif v_direction==-1:
		set_anim("walk_back")
		set_flip(false)
	elif direction==1:
		set_anim("walk_side")
		set_flip(false)
	elif direction ==-1:
		set_flip(true)
		set_anim("walk_side")
	
	move_and_slide()
