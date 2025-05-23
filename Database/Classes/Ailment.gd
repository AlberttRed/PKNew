class_name Ailment
extends Resource

@export var id: String                # ID interno o el de PokeAPI, como "paralysis"
@export var display_name: String     # Nombre visible ("Parálisis")
@export var description: String = "" # Texto opcional descriptivo
@export var icon: Texture2D = null   # Icono opcional para mostrar en batalla
@export var is_persistent: bool = true  # Si persiste fuera de combate o al hacer switch
@export var effect: Resource = null        # Script del PersistentBattleEffect asociado

func get_effect():
	return effect.new(self) if effect != null else null
