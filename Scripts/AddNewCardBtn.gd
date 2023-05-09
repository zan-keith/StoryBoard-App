extends PanelContainer

onready var PopupPane=$PopupPanel
signal AddCard
onready var RecentlyClickedCard=1
onready var toggle=false
onready var card_added_oneshot=false

func AddCard(n):
	print('before ',$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid".rect_size)
	var c
	var latest_index=$"../../..".latest_index
	if n==1:
		c = load("res://Scenes/StoryCard.tscn").instance()
		c.connect("SendClick", self, "_on_card_click")
		c.connect("RefreshLines", self, "_on_refresh_lines")
		c.get_node("VBoxContainer/MainDetails/Index").text=str(latest_index)
		#get_node(maingrid_path).add_child(c)
		
	elif n==2:
		c = load("res://Scenes/RouterCard.tscn").instance()
		c.connect("SendClick", self, "_on_card_click")
		c.connect("RefreshLines", self, "_on_refresh_lines")
		c.get_node('VBoxContainer/HBox/Index').text=str(latest_index)
		#get_node(maingrid_path).add_child(c)
	elif n==3:
		c = load("res://Scenes/ChoiceCard.tscn").instance()
		c.connect("SendClick", self, "_on_card_click")
		c.connect("RefreshLines", self, "_on_refresh_lines")
		c.get_node("VBoxContainer/MainDetails/Index").text=str(latest_index)
		#get_node(maingrid_path).add_child(c)

	$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid".add_child(c)
	print(c.rect_size.x,$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid".rect_size)
	
	if not card_added_oneshot:
		$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid".rect_size+=Vector2(c.rect_size.x,0)
	
	$"../../../PanelContainer/ScrollContainer/Panel".rect_min_size=$"../../../PanelContainer/ScrollContainer/Panel/MarginContainer/MainGrid".rect_size
	$"../../..".latest_index+=1

func popup():
	if toggle:
		 $"../../AnimationPlayer".play("popup_panel_open")
	else:
		$"../../AnimationPlayer".play("popup_panel_close")

func _on_AddBtn_toggled(button_pressed):
	toggle=not toggle
	popup()


func _on_AddIconBtn_toggled(button_pressed):
	toggle=not toggle
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
	$"../../AnimationPlayer".play("popup_panel_close")


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
