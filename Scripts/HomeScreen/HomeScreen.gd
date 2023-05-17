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
		$Board/HBoxContainer/PanelContainer2/VBoxContainer/PanelContainer/VBoxContainer/FilePath.set_text('C:\\Users\\godla\\Documents\\StoryFiles')
		$Board/HBoxContainer/PanelContainer2/VBoxContainer/PanelContainer/VBoxContainer/FilePath.set_editable(false)


func CreateFile():
	var template=$Board/HBoxContainer/PanelContainer2/VBoxContainer/PanelContainer/VBoxContainer/CheckButton.pressed
	var file_name=$Board/HBoxContainer/PanelContainer2/VBoxContainer/PanelContainer/VBoxContainer/FileName.get_text()
	var path=$Board/HBoxContainer/PanelContainer2/VBoxContainer/PanelContainer/VBoxContainer/FilePath.get_text()
	
	path=path+'//'+file_name
	
	if template:
		var template_file = File.new()
		template_file.open("res://Assets//Template//sampletemplate.json", template_file.READ)
		var template_file_text = template_file.get_as_text()
		var result_json = JSON.parse(str(template_file_text))
		var text = result_json.result
		template_file.close()
		
		var file = File.new()
		file.open(path, File.WRITE)
		file.store_string(JSON.print(text))
		file.close()
		
		_on_open_file_click(path)
	else:
		var file = File.new()
		file.open(path, File.WRITE)
		file.store_string(JSON.print({"story_line":[]}))
		file.close()
		_on_open_file_click(path)
	

func _on_open_file_click(path):
	var s = load("res://MainBoard.tscn").instance()
	s.path_to_json=path
	get_tree().get_root().add_child(s)
	get_tree().set_current_scene(s)
	
