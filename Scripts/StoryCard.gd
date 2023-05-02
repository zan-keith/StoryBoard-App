extends PanelContainer


func _ready():
	print($Line2D.get_points())
	

func _on_AddVar_pressed():
	var var_details = load("res://Scenes/StoryCard/VarDetails.tscn").instance()
	get_node("./VBoxContainer/OnStart/VBox/Reqs").add_child(var_details)
	var_details.visible=true

func _on_OnEndAddVar_pressed():
	var var_details = load("res://Scenes/StoryCard/VarDetails.tscn").instance()
	get_node("./VBoxContainer/OnEnd/VBoxContainer/SetVars").add_child(var_details)
	var_details.visible=true
	

func DrawLine():
	$"../../../.."
	$Line2D.set_points(PoolVector2Array([Vector2(0, 100), Vector2(-16, 100),Vector2(-16,500)]))





func _on_EditButton_pressed():
	$VBoxContainer/Content/TypeContent.visible=true
	$VBoxContainer/Content/TypeContent.text=$VBoxContainer/Content/ContentLabel.get_text()


func _on_SaveContentButton_pressed():
	$VBoxContainer/Content/TypeContent.visible=false
	$VBoxContainer/Content/ContentLabel.set_text($VBoxContainer/Content/TypeContent.get_text())

#
#
#func _on_StoryCard_mouse_entered():
#	$VBoxContainer/AnimationPlayer.play("mouse_enter")
#	print('enter')
#
#
#
#func _on_StoryCard_mouse_exited():
#	$VBoxContainer/AnimationPlayer.play("mouse_exit")
#	print('exit')
#


func _on_HoverCheck_mouse_entered():
	$VBoxContainer/AnimationPlayer.play("mouse_enter")


func _on_HoverCheck_mouse_exited():
	$VBoxContainer/AnimationPlayer.play("mouse_exit")


func _on_Save_pressed():
	DrawLine()
#	print($Line2D.get_points())
