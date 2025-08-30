extends Node


var atlas_image := preload("res://spritesheet_characters.png")

func _ready():
	# Make sure output folder exists
	var dir := DirAccess.open("res://")
	if not dir.dir_exists("res://atlas_textures"):
		dir.make_dir("res://atlas_textures")

	var xml := XMLParser.new()
	var err := xml.open("res://spritesheet_characters.xml")
	if err != OK:
		push_error("Failed to open XML file")
		return

	while xml.read() == OK:
		if xml.get_node_type() == XMLParser.NODE_ELEMENT and xml.get_node_name() == "SubTexture":
			var name := xml.get_named_attribute_value("name")
			var x := int(xml.get_named_attribute_value("x"))
			var y := int(xml.get_named_attribute_value("y"))
			var w := int(xml.get_named_attribute_value("width"))
			var h := int(xml.get_named_attribute_value("height"))

			var atlas_tex := AtlasTexture.new()
			atlas_tex.atlas = atlas_image
			atlas_tex.region = Rect2(x, y, w, h)

			var save_path := "res://atlas_textures/%s.tres" % name
			var save_err := ResourceSaver.save(atlas_tex, save_path)
			if save_err != OK:
				push_error("Failed to save: %s" % save_path)

	print("✅ Done generating textures into res://atlas_textures/")
