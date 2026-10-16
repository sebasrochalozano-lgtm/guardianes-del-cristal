extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	# El portal comienza oculto e inactivo.
	hide()
	monitoring = false
	collision_shape.disabled = true

	# Escuchar cuando se complete la misión.
	if not QuestManager.quest_completed.is_connected(_on_quest_completed):
		QuestManager.quest_completed.connect(_on_quest_completed)

	# Por seguridad, si la misión ya estaba completada.
	if QuestManager.quest_state == QuestManager.QuestState.COMPLETED:
		activate_portal()

	# Detectar al jugador cuando entre.
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_quest_completed() -> void:
	activate_portal()


func activate_portal() -> void:
	show()
	monitoring = true
	collision_shape.set_deferred("disabled", false)

	print("PORTAL ACTIVADO")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("EL JUGADOR ENTRO AL PORTAL")
