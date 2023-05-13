extends Control


func _ready():
	var files=list_files_in_directory()
	for file in files:
		var node = load("res://Scenes/HomeScreen/QuickOpenFile.tscn").instance()
		var path=file[0]+'\\'+file[1]
		node.get_node('VBoxContainer/Label').set_text(path)
		node.get_node('VBoxContainer/Button').set_text(file[1])
		
		node.get_node('VBoxContainer/Button').connect('pressed',self,'_on_open_file_click',[path])
		
		$Board/HBoxContainer/PanelContainer/ScrollContainer/VBoxContainer/PanelContainer/VBoxContainer/VBoxContainer.add_child(node)


func list_files_in_directory():
	var path="C:\\Users\\godla\\Documents\\StoryFiles"
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.get_extension()=='json':
			files.append([path,file])

	dir.list_dir_end()

	return files


func _on_OpenFile_pressed():
	$FileDialog.popup()


func _on_FileDialog_file_selected(path):
	var s = load("res://MainBoard.tscn").instance()
	s.path_to_json=path
	get_tree().get_root().add_child(s)
	get_tree().set_current_scene(s)


func _on_Default_Path_CheckBox_toggled(button_pressed):
	if not button_pressed:
		$Board/HBoxContainer/PanelContainer2/VBoxContainer/PanelContainer/VBoxContainer/FilePath.set_editable(true)
	else:
		$Board/HBoxContainer/PanelContainer2/VBoxContainer/PanelContainer/VBoxContainer/FilePath.set_text('default/path/to/file')
		$Board/HBoxContainer/PanelContainer2/VBoxContainer/PanelContainer/VBoxContainer/FilePath.set_editable(false)


func CreateFile():
	var template=$Board/HBoxContainer/PanelContainer2/VBoxContainer/PanelContainer/VBoxContainer/CheckButton.pressed
	var filename=$Board/HBoxContainer/PanelContainer2/VBoxContainer/PanelContainer/VBoxContainer/FileName.get_text()
	var path=$Board/HBoxContainer/PanelContainer2/VBoxContainer/PanelContainer/VBoxContainer/FilePath.get_text()
	
	#path+'//'+filename
	

func _on_open_file_click(path):

	var s = load("res://MainBoard.tscn").instance()
	s.path_to_json=path
	get_tree().get_root().add_child(s)
	get_tree().set_current_scene(s)
	
