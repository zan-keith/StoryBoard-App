extends PanelContainer

signal AddCard
onready var RecentlyClickedCard=1
onready var toggle=false
onready var card_added_oneshot=false

func AddCard(n):
	var maingrid_path="../../../PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid"
	#print('before ',$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid".get_size())
	#print('before',$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer".get_size())
	var MainBoard=$"../../.."
	var c
	var latest_index=$"../../..".latest_index
	if n==1:
		c = load("res://Scenes/StoryCard.tscn").instance()
		c.connect("SendClick", MainBoard, "_on_card_click")
		c.connect("RefreshLines", MainBoard, "_on_refresh_lines")
		c.get_node("VBoxContainer/MainDetails/Index").text=str(latest_index)
		get_node(maingrid_path).add_child(c)
		
	elif n==2:
		c = load("res://Scenes/RouterCard.tscn").instance()
		c.connect("SendClick", MainBoard, "_on_card_click")
		c.connect("RefreshLines", MainBoard, "_on_refresh_lines")
		c.get_node('VBoxContainer/HBox/Index').text=str(latest_index)
		get_node(maingrid_path).add_child(c)
	elif n==3:
		c = load("res://Scenes/ChoiceCard.tscn").instance()
		c.connect("SendClick", MainBoard, "_on_card_click")
		c.connect("RefreshLines", MainBoard, "_on_refresh_lines")
		c.get_node("VBoxContainer/MainDetails/Index").text=str(latest_index)
		get_node(maingrid_path).add_child(c)
	get_node(maingrid_path)._set_size(get_node(maingrid_path).get_size())
	$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer"._set_size(get_node(maingrid_path).get_size())
	
	#print('after',get_node(maingrid_path).get_size())
	#print('after',$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer".get_size())
	
	$"../../../PanelContainer/ScrollContainer/Panel".set_custom_minimum_size($"../../../PanelContainer/ScrollContainer/Panel/MarginContainer".get_size()*$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer".rect_scale)
	
	
	$"../../..".latest_index+=1

func popup():
	if toggle:
		
		$"../../../SelectCardPopup".popup()

		var x_ax=($".".get_global_position())
		$"../../../SelectCardPopup".set_position(x_ax+Vector2(0,$".".get_size().y))

		$"../../AnimationPlayer".play("popup_panel_open")
#
#	else:
#		$"../../AnimationPlayer".play("popup_panel_close")

func _on_AddBtn_toggled(button_pressed):
	toggle=true
	popup()


func _on_AddIconBtn_toggled(button_pressed):
	toggle=true
	popup()
	
func QuickAddBtn(n):
	if n==1:
		$HBox/QuickAddBtn.texture_normal=load("res://Assets/Textures/gui-tooltip-svgrepo-com (1).png")
	elif n==2:
		$HBox/QuickAddBtn.texture_normal=load("res://Assets/Textures/shuffle-svgrepo-com.png")
	elif n==3:
		$HBox/QuickAddBtn.texture_normal=load("res://Assets/Textures/options-svgrepo-com.png")
#	emit_signal('AddCard',n)
	AddCard(n)

func AddBtn(n):
	RecentlyClickedCard=n
	if n==1:
		$HBox/QuickAddBtn.texture_normal=load("res://Assets/Textures/gui-tooltip-svgrepo-com (1).png")
	elif n==2:
		$HBox/QuickAddBtn.texture_normal=load("res://Assets/Textures/shuffle-svgrepo-com.png")
	elif n==3:
		$HBox/QuickAddBtn.texture_normal=load("res://Assets/Textures/options-svgrepo-com.png")
	AddCard(n)
#	emit_signal('AddCard',n)



func _on_StoryButton_pressed():
	AddBtn(1)
	print('pressed')
func _on_StoryTextureButton_pressed():
	AddBtn(1)

func _on_RouterButton_pressed():
	AddBtn(2)
func _on_RouterTextureButton_pressed():
	AddBtn(2)

func _on_ChoiceButton_pressed():
	AddBtn(3)
func _on_ChoiceTextureButton_pressed():
	AddBtn(3)



func _on_QuickAddBtn_pressed():
	QuickAddBtn(RecentlyClickedCard)
	$"../../AnimationPlayer".play("quick_add_btn")


func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.get_button_index()!=5 and event.get_button_index()!=4:
		if event.is_pressed():
			toggle=not toggle
			popup()



func _on_Story_mouse_entered():
	$"../../AnimationPlayer".play("add_story_card_hover")

func _on_Story_mouse_exited():
	$"../../AnimationPlayer".play("reset_add_buttons_hover")


func _on_Router_mouse_entered():
	$"../../AnimationPlayer".play("add_router_card_hover")

func _on_Router_mouse_exited():
	$"../../AnimationPlayer".play("reset_add_buttons_hover")


func _on_Choice_mouse_entered():
	$"../../AnimationPlayer".play("add_choice_card_hover")

func _on_Choice_mouse_exited():
	$"../../AnimationPlayer".play("reset_add_buttons_hover")
