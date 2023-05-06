extends PanelContainer

onready var PopupPane=$PopupPanel
signal AddCard
onready var RecentlyClickedCard=1

func _on_AddBtn_toggled(button_pressed):
	if button_pressed:
		PopupPane.visible=true
	else:
		PopupPane.visible=false


func _on_AddIconBtn_toggled(button_pressed):
	if button_pressed:
		PopupPane.visible=true
	else:
		PopupPane.visible=false

func AddBtn(n):
	RecentlyClickedCard=n
	if n==1:
		$HBox/QuickAddBtn.texture_normal=load("res://Assets/Textures/gui-tooltip-svgrepo-com (1).png")
	elif n==2:
		$HBox/QuickAddBtn.texture_normal=load("res://Assets/Textures/shuffle-svgrepo-com.png")
	elif n==3:
		$HBox/QuickAddBtn.texture_normal=load("res://Assets/Textures/options-svgrepo-com.png")

	emit_signal('AddCard',n)
	PopupPane.visible=false


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
	AddBtn(RecentlyClickedCard)
