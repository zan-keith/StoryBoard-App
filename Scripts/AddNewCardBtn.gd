extends PanelContainer

signal AddCard
signal ShowToast
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
		c.connect('ShowOptionsPopup',MainBoard,'_on_card_right_click')
		c.get_node("VBoxContainer/MainDetails/Index").text=str(latest_index)

	elif n==2:
		c = load("res://Scenes/RouterCard.tscn").instance()
		c.connect("SendClick", MainBoard, "_on_card_click")
		c.connect("RefreshLines", MainBoard, "_on_refresh_lines")
		c.connect('ShowOptionsPopup',MainBoard,'_on_card_right_click')
		c.get_node('VBoxContainer/HBox/Index').text=str(latest_index)

	elif n==3:
		c = load("res://Scenes/ChoiceCard.tscn").instance()
		c.connect("SendClick", MainBoard, "_on_card_click")
		c.connect("RefreshLines", MainBoard, "_on_refresh_lines")
		c.connect('ShowOptionsPopup',MainBoard,'_on_card_right_click')
		c.get_node("VBoxContainer/MainDetails/Index").text=str(latest_index)
	get_node(maingrid_path).add_child(c)
	get_node(maingrid_path)._set_size(get_node(maingrid_path).get_size())
	$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer"._set_size(get_node(maingrid_path).get_size())
	
	#print('after',get_node(maingrid_path).get_size())
	#print('after',$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer".get_size())
	
	$"../../../PanelContainer/ScrollContainer/Panel".set_custom_minimum_size($"../../../PanelContainer/ScrollContainer/Panel/MarginContainer".get_size()*$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer".rect_scale)
	
	
	$"../../..".latest_index+=1

	return c
	
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

func Tidy_Order():
	var index=1
	var children=$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid".get_children()
	for child in children:

		if child.is_in_group('RouterCard'):
			child.get_node('VBoxContainer/HBox/Index').text=str(index)
		elif child.is_in_group('StoryCard'):
			child.get_node("VBoxContainer/MainDetails/Index").text=str(index)
		elif child.is_in_group('ChoiceCard'):
			child.get_node("VBoxContainer/MainDetails/Index").text=str(index)

		
		index+=1
	$"../../..".latest_index=index
func _on_StoryCardAdd_pressed():
	
	if $"../../..".prevcard!=null:
		var card=AddCard(1)
		var prev_card_index=get_node('../../../PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid/'+$"../../..".prevcard).get_index()
		$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid".move_child(card,prev_card_index+1)
		Tidy_Order()
	else:
		emit_signal("ShowToast",'Invalid Card - Select a card which you need to add new card infront of')
	

func _on_RouterCardAdd_pressed():
	if $"../../..".prevcard!=null:
		var card=AddCard(2)
		var prev_card_index=get_node('../../../PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid/'+$"../../..".prevcard).get_index()
		$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid".move_child(card,prev_card_index+1)
		Tidy_Order()
	else:
		emit_signal("ShowToast",'Invalid Card - Select a card which you need to add new card infront of')
	


func _on_ChoiceCardAdd_pressed():
	if $"../../..".prevcard!=null:
		var card=AddCard(3)
		var prev_card_index=get_node('../../../PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid/'+$"../../..".prevcard).get_index()
		$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid".move_child(card,prev_card_index+1)
		Tidy_Order()
	else:
		emit_signal("ShowToast",'Invalid Card - Select a card which you need to add new card infront of')
	
