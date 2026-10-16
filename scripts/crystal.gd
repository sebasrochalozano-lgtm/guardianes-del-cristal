extends Area2D

signal collected

var was_collected: bool = false


func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if was_collected:
		return

	if not body.is_in_group("player"):
		return

	# QuestManager decide si el cristal puede recogerse.
	# Si la misión no está ACTIVE, devuelve false.
	if not QuestManager.collect_crystal():
		return

	was_collected = true
	collected.emit()
	queue_free()
