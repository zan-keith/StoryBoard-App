extends PanelContainer

onready var PopupPane=$PopupPanel
signal AddCard
onready var RecentlyClickedCard=1
onready var toggle=false


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
	emit_signal('AddCard',n)

func AddBtn(n):
	RecentlyClickedCard=n
	if n==1:
		$HBox/QuickAddBtn.texture_normal=load("res://Assets/Textures/gui-tooltip-svgrepo-com (1).png")
	elif n==2:
		$HBox/QuickAddBtn.texture_normal=load("res://Assets/Textures/shuffle-svgrepo-com.png")
	elif n==3:
		$HBox/QuickAddBtn.texture_normal=load("res://Assets/Textures/options-svgrepo-com.png")

	emit_signal('AddCard',n)
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
	pass



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
