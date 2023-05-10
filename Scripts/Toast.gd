extends CenterContainer




func _on_MainBoard_ShowToast(text):
	$Toast/HBoxContainer/Label.text=text
	$Toast/AnimationPlayer.play("popup_and_out")
