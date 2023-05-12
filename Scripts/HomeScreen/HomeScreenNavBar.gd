extends ScrollContainer

onready var Settings_btn=$HBoxContainer/RightNav/Settings

onready var Animation_player=$AnimationPlayer


func _on_Settings_mouse_entered():
	Settings_btn.rect_pivot_offset=Settings_btn.rect_size/2
	Animation_player.play("clockwise_rotate")
	


func _on_Settings_mouse_exited():
	Settings_btn.rect_pivot_offset=Settings_btn.rect_size/2
	Animation_player.play("anti_clockwise_rotate")




func _on_LineEdit_focus_entered():
	Animation_player.play("search_bar_focus")


func _on_LineEdit_focus_exited():
	Animation_player.play("search_bar_unfocus")


