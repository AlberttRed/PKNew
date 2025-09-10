@tool
extends EditorScript

const MOVES_PATH := "res://Resources/Moves/"
const AILMENTS_PATH := "res://Resources/Ailments/"

func _run():
	var moves_ailments: Dictionary = {}
	print("🔄 Importando habilidades desde PokeAPI...")
	var http = HTTPClient.new()
	var err = http.connect_to_host("pokeapi.co", 443, TLSOptions.client())
	if err != OK:
		print("❌ Error conectando a PokeAPI")
		return ""

	while http.get_status() in [HTTPClient.STATUS_CONNECTING, HTTPClient.STATUS_RESOLVING]:
		http.poll()
		OS.delay_msec(50)

	assert(http.get_status() == HTTPClient.STATUS_CONNECTED)


	for i in range(1, 622): # Hay 621 movimientos cargados
		var text = get_json(http, err, "/api/v2/move/" + str(i) + "/")
		if text == null or text == "":
			print("⏭️ Saltando movimiento #" + str(i))
			continue

		var json_object = JSON.new()
		var parse_err = json_object.parse(text)
		if parse_err != OK:
			print("⚠️ Error parseando movimiento #" + str(i))
			continue

		var data = json_object.get_data()
		var move_resource_name:String = "%03d" % [i] + ".tres"
		var move:Move = load(MOVES_PATH + move_resource_name)
		
		#SAVE AILMENT TO MOVE
		#reload_ailments(i, move, data)
		
		reload_stat_chnges(i, move, data)
		print(move.Name)
		print(move.stat_changes)
		var save_path = MOVES_PATH + move_resource_name
		move.take_over_path(save_path)
		var err2 = ResourceSaver.save(move, save_path)
		if err2 != OK:
			print("❌ Error guardando: " + save_path)
		else:
			print("✅ Guardada: " + save_path)

	print("🎉 ¡Importación de habilidades completada!")

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

func reload_ailments(i:int, move:Move, data):
	var ailment_name:String = data["meta"]["ailment"]["name"]
	if ailment_name != "none":
		#var filename = "%03d-%s.tres" % [ability.id, ability.internal_name.to_upper().replace("_", "-")]
		print("%03d " % [i] + ailment_name)

		var ailment_resource_name:String = ailment_name.to_upper() + ".tres"
		if FileAccess.file_exists(AILMENTS_PATH + ailment_resource_name):
			
			var ailment:Ailment = load(AILMENTS_PATH + ailment_resource_name)
			move.ailment = ailment
			print(move.ailment.id)

func reload_stat_chnges(i:int, move:Move, data):
	var stat_changes:Array = data["stat_changes"]
	move.stat_change_ids = []
	move.stat_change_valors = []
	move.stat_changes = {}
	for stat in stat_changes:
		var stat_name = stat["stat"]["name"]
		var value:int = stat["change"]
		var stat_type:StatTypes.Stat
		
		match stat_name:
			"attack":
				stat_type = StatTypes.Stat.ATTACK
			"defense":
				stat_type = StatTypes.Stat.DEFENSE
			"special-attack":
				stat_type = StatTypes.Stat.SP_ATTACK
			"special-defense":
				stat_type = StatTypes.Stat.SP_DEFENSE
			"speed":
				stat_type = StatTypes.Stat.SPEED
			"accuracy":
				stat_type = StatTypes.Stat.ACCURACY
			"evasion":
				stat_type = StatTypes.Stat.EVASION
			_:
					push_error("INVALID STAT")
		print(stat_name + ": " + str(value))
		
		move.stat_changes[stat_type] = value

	
