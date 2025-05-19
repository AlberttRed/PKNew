@tool
extends EditorScript

const ABILITY_PATH := "res://Resources/Abilities/"
const ABILITY_CLASS := preload("res://Database/Classes/Ability.gd")

func _run():
	print("🔄 Importando habilidades desde PokeAPI...")

	for i in range(1, 233): # Hay 232 habilidades numeradas oficialmente
		var text = get_json("/api/v2/ability/" + str(i) + "/")
		if text == null or text == "":
			print("⏭️ Saltando habilidad #" + str(i))
			continue

		var json_object = JSON.new()
		var parse_err = json_object.parse(text)
		if parse_err != OK:
			print("⚠️ Error parseando habilidad #" + str(i))
			continue

		var data = json_object.get_data()
		var ability = ABILITY_CLASS.new()
		ability.id = data["id"]
		ability.internal_name = data["name"]

		for name_entry in data["names"]:
			if name_entry["language"]["name"] == "es":
				ability.display_name = name_entry["name"]
				break

		for flavor in data["flavor_text_entries"]:
			if flavor["language"]["name"] == "es":
				ability.description = flavor["flavor_text"].replace("\n", " ").strip_edges()
				break

		var filename = "%03d-%s.tres" % [ability.id, ability.internal_name.to_upper().replace("_", "-")]
		var save_path = ABILITY_PATH + filename

		var err = ResourceSaver.save(ability, save_path)
		if err != OK:
			print("❌ Error guardando: " + save_path)
		else:
			print("✅ Guardada: " + filename)

	print("🎉 ¡Importación de habilidades completada!")

func get_json(uri: String) -> String:
	var http = HTTPClient.new()
	var err = http.connect_to_host("pokeapi.co", 443, TLSOptions.client())
	if err != OK:
		print("❌ Error conectando a PokeAPI")
		return ""

	while http.get_status() in [HTTPClient.STATUS_CONNECTING, HTTPClient.STATUS_RESOLVING]:
		http.poll()
		OS.delay_msec(50)

	assert(http.get_status() == HTTPClient.STATUS_CONNECTED)

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
