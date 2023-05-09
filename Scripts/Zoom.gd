extends PanelContainer

onready var curr_zoom=100

func zoom(percentage):
	var label_val = (percentage/0.5)*100
	var zoom_container=$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer"

	if zoom_container.rect_scale.x+percentage<=1 and zoom_container.rect_scale.x+percentage>=0.5:

		zoom_container.rect_scale.x+=percentage
		zoom_container.rect_scale.y+=percentage

		zoom_container._set_size(zoom_container.get_size())
		
		$PanelContainer/HBoxContainer/Label.text=str(label_val+int($PanelContainer/HBoxContainer/Label.text))
		$"../../../PanelContainer/ScrollContainer/Panel".set_custom_minimum_size(zoom_container.rect_size*zoom_container.rect_scale)
		$"../../../PanelContainer/ScrollContainer/Panel"._set_size($"../../../PanelContainer/ScrollContainer/Panel".get_custom_minimum_size())
		#$"../../../PanelContainer/ScrollContainer".rect_size=zoom_container.rect_size*zoom_container.rect_scale
	#var label_val = (percentage/0.5)*100
	#var cards=$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid".get_children()

#
#	for card in cards:
#		card.rect_scale.x+=percentage
#		card.rect_scale.y+=percentage
	
	#$"../../../PanelContainer/ScrollContainer/Panel".set_custom_minimum_size($"../../../PanelContainer/ScrollContainer/Panel".get_custom_minimum_size()+Vector2(186,0))

func _on_minus_pressed():
	zoom(-0.05)


func _on_plus_pressed():
	zoom(+0.05)


func _on_MainBoard_ZoomSet():
	zoom(-0.05)
	pass
