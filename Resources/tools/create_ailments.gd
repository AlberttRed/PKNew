@tool
extends EditorScript

const AILMENTS_PATH := "res://Resources/Ailments/"

func _run():
	var moves_ailments: Dictionary = {}
	print("🔄 Importando ailments desde PokeAPI...")
	var http = HTTPClient.new()
	var err = http.connect_to_host("pokeapi.co", 443, TLSOptions.client())
	if err != OK:
		print("❌ Error conectando a PokeAPI")
		return ""

	while http.get_status() in [HTTPClient.STATUS_CONNECTING, HTTPClient.STATUS_RESOLVING]:
		http.poll()
		OS.delay_msec(50)

	assert(http.get_status() == HTTPClient.STATUS_CONNECTED)


	for i in range(1, 20): # Hay 19 ailments
		var text = get_json(http, err, "/api/v2/move-ailment/" + str(i) + "/")
		if text == null or text == "":
			print("⏭️ Saltando ailment #" + str(i))
			continue

		var json_object = JSON.new()
		var parse_err = json_object.parse(text)
		if parse_err != OK:
			print("⚠️ Error parseando ailment #" + str(i))
			continue

		var data = json_object.get_data()
		#var move = preload("%03d")
		var ailment_name:String = data["name"]
		
	
		#var filename = "%03d-%s.tres" % [ability.id, ability.internal_name.to_upper().replace("_", "-")]
		
		var ailment_resource_name:String = ailment_name.to_upper() + ".tres"
		print(ailment_resource_name)
		if !FileAccess.file_exists(AILMENTS_PATH + ailment_resource_name):
			var save_path = AILMENTS_PATH + ailment_resource_name
			var ailment:Ailment = Ailment.new()
			ailment.id = ailment_name
			ailment.display_name = data["names"][1]["name"]
			ailment.is_persistent = ailment_name in ["paralysis","sleep","freeze","burn","poison"]
			#move.ailment = ailment
			#print(move.Name)
			#print(move.ailment.id)
			#
			#move.take_over_path(save_path)
			var err2 = ResourceSaver.save(ailment, save_path)
			if err2 != OK:
				print("❌ Error guardando: " + save_path)
			else:
				print("✅ Guardada: " + save_path)

	print("🎉 ¡Importación de ailments completada!")

func get_json(http, err, uri: String) -> String:

	var headers = [
		"User-Agent: Godot"
	]
	err = http.request(HTTPClient.METHOD_GET, uri, headers)
	if err != OK:
		print("❌ Error enviando petición GET")
		return ""

	while http.get_status() == HTTPClient.STATUS_REQUESTING:
		http.poll()
		OS.delay_msec(50)

	var rb := PackedByteArray()
	while http.get_status() == HTTPClient.STATUS_BODY:
		http.poll()
		var chunk = http.read_response_body_chunk()
		if chunk.is_empty():
			OS.delay_msec(10)
		else:
			rb += chunk

	return rb.get_string_from_utf8()
