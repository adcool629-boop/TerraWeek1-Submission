extends Node2D

@onready var objective: Label = $CanvasLayer/Objective
@onready var player_light: PointLight2D = $Player/PlayerLight
@onready var player: CharacterBody2D = $Player
@onready var health_bar: TextureProgressBar = $CanvasLayer/HealthBar
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
var Phealth: int = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_modulate.visible = false
	player_light.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cave_tp_body_entered(body: Node2D) -> void:
	player.position = Vector2(14149.909,19.909)
	canvas_modulate.visible = true
	player_light.visible = true
	objective.text = "Navigate through \n the cave"
func _on_beginning_tp_body_entered(body: Node2D) -> void:
	player.position = Vector2(2504.0,296.0)
	canvas_modulate.visible = false
	player_light.visible = false
	objective.text = "Defeat The Slimes and \n get to the cave"
func _on_town_tp_body_entered(body: Node2D) -> void:
	player.position = Vector2(5916.0,7862.0)
	canvas_modulate.visible = false
	player_light.visible = false
	objective.text = "Find and get to \n the note"
func _on_cave_tp_2_body_entered(body: Node2D) -> void:
	player.position = Vector2(11423.346,-387.05)
	canvas_modulate.visible = true
	player_light.visible = true
	objective.text = "Navigate through \n the cave"
	

		
func _on_player_player_died() -> void:
	get_tree().reload_current_scene()
