extends PopupPanel

signal ShowToast

onready var default_settings
onready var user_settings

func _ready():
	default_settings=load_default_settings()
	user_settings=load_user_settings()
	
	if not user_settings:
		user_settings=default_settings
		var dir = Directory.new()
		if not dir.dir_exists('user://Settings'):
			dir.open("user://")
			dir.make_dir("Settings")
		save()
	print(user_settings)
	
	Initialize()
	
	
func save():
	var file = File.new()
	file.open("user://Settings//user_settings.json", File.WRITE)
	file.store_string(JSON.print(user_settings))
	file.close()
	emit_signal("ShowToast","Saved Succesfully")

func load_user_settings():
	var file = File.new()
	var directory = Directory.new()
	if not directory.file_exists("user://Settings//user_settings.json"):
		return false
	file.open("user://Settings//user_settings.json", file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(str(text))
	var re_user_settings = result_json.result
	file.close()
	return re_user_settings

func load_default_settings():
	var file2 = File.new()
	var directory2 = Directory.new()
	if not directory2.file_exists("res://Assets/Settings/default_settings.json"):
		return false
	
	file2.open("res://Assets/Settings/default_settings.json", file2.READ)
	var text2 = file2.get_as_text()
	var result_json2 = JSON.parse(str(text2))
	var re_default_settings = result_json2.result
	file2.close()
	return re_default_settings


func _on_HSlider_value_changed(value):
	$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.set_text(str(value))

func _on_Font_Size_HSlider_value_changed(value):
	$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer2/LineEdit2.set_text(str(value))



func _on_LineEdit_text_entered(new_text):
	if (str(new_text).is_valid_integer() and int(new_text)>=0 and int(new_text)<=100):
		$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/HSlider.value=int(new_text)


func _on_LineEdit2_text_entered(new_text):
	if (str(new_text).is_valid_integer() and int(new_text)>=0 and int(new_text)<=100):
		$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer2/HSlider.value=int(new_text)

func _on_Default_FilePath_CheckBox_toggled(button_pressed):
	if button_pressed:
		$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer3/VBoxContainer/HBoxContainer/LineEdit.set_text(default_settings['save_location'])
		$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer3/VBoxContainer/HBoxContainer/LineEdit.editable=false
	else:
		$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer3/VBoxContainer/HBoxContainer/LineEdit.editable=true

func _on_Revert_To_Default_pressed():
	$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.set_text(default_settings['card_size'])
	$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/HSlider.value=int(default_settings['card_size'])
	
	$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer2/LineEdit2.set_text(default_settings['font_size'])
	$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer2/HSlider.value=int(default_settings['font_size'])
	
	$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer3/VBoxContainer/HBoxContainer/LineEdit.set_text(default_settings['save_location'])
	$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer3/VBoxContainer/CheckBox.pressed=true
	

func Initialize():
	$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.set_text(user_settings['card_size'])
	$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/HSlider.value=int(user_settings['card_size'])
	
	$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer2/LineEdit2.set_text(user_settings['font_size'])
	$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer2/VBoxContainer/HBoxContainer2/HSlider.value=int(user_settings['font_size'])
	
	$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer3/VBoxContainer/HBoxContainer/LineEdit.set_text(user_settings['save_location'])




func _on_SettingsPanel_popup_hide():
	user_settings['card_size']=$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.get_text()
	user_settings['font_size']=$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/LineEdit.get_text()
	user_settings['save_location']=$VBoxContainer/ScrollContainer/PanelContainer/VBoxContainer/PanelContainer3/VBoxContainer/HBoxContainer/LineEdit.get_text()
	
	
	save()
	
	
