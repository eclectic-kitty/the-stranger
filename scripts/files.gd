extends GDScript


# This loads all the files in a directory as resources into an array
func list_files(path):
	var file_list = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true, true)
	
	while true:
		var file = dir.get_next()
		if file == "": 
			break
		elif file.ends_with(".import"):
			file = file.replace(".import", "")
			var res = load(path + file)
			file_list.append(res)
	return file_list
