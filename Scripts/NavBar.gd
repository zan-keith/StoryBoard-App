extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

onready var Settings_btn=$HBoxContainer/RightNav/Settings
onready var Minus_btn=$HBoxContainer/Zoom/PanelContainer/HBoxContainer/minus
onready var Plus_btn=$HBoxContainer/Zoom/PanelContainer/HBoxContainer/plus

onready var Animation_player=$AnimationPlayer

func _on_Settings_mouse_entered():
	Settings_btn.rect_pivot_offset=Settings_btn.rect_size/2
	Animation_player.play("clockwise_rotate")
	


func _on_Settings_mouse_exited():
	Settings_btn.rect_pivot_offset=Settings_btn.rect_size/2
	Animation_player.play("anti_clockwise_rotate")




func _on_plus_mouse_entered():
	Plus_btn.rect_pivot_offset=Plus_btn.rect_size/2
	Animation_player.play("magnify_plus")

func _on_plus_mouse_exited():
	Plus_btn.rect_pivot_offset=Plus_btn.rect_size/2
	Animation_player.play("shrink_plus")
	

func _on_minus_mouse_entered():
	Minus_btn.rect_pivot_offset=Minus_btn.rect_size/2
	Animation_player.play("magnify_minus")

	

func _on_minus_mouse_exited():
	Minus_btn.rect_pivot_offset=Minus_btn.rect_size/2
	Animation_player.play("shrink_minus")
	




func _on_LineEdit_focus_entered():
	Animation_player.play("search_bar_focus")


func _on_LineEdit_focus_exited():
	Animation_player.play("search_bar_unfocus")
