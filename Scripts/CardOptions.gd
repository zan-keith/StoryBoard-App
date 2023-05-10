extends PanelContainer


func _on_Options_pressed():
	$"../../../PopupMenu".popup()

	var x_ax=($Options.get_global_position()+Vector2($Options.get_size().x/2,0))-Vector2($"../../../PopupMenu".get_size().x/2,0)
	$"../../../PopupMenu".set_position(x_ax+Vector2(0,$Options.get_size().y))
