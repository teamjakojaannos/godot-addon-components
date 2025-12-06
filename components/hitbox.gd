@tool
class_name Hitbox
extends Area2D
## A region of 2D space that can accept incoming damage.

## Targeted health component. Any received damage is applied to this.
@export var health: Health
## Damage multiplier for this hitbox. Useful for e.g. enemy weakspots.
@export var multiplier: int = 1

var enabled: bool:
	get:
		return monitorable
	set(value):
		set_deferred("monitorable", value)


func _ready() -> void:
	health = Nodes.find_if_null(self, health, Health)
