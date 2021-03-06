"""
filename: hud.gd
"""

extends CanvasLayer

const HealthBar = preload("health_bar.gd")

onready var GUI = $GUI

func _ready():
  if DBG.DEBUG:
    get_foot().add_child(DBG.ARM_INSPECT.instance())

func get_health_bar() -> HealthBar:
  return get_head("/HealthBar") as HealthBar

func get_head(child_path:="") -> HBoxContainer:
  if child_path and child_path[0] != '/':
    child_path = "/%s" % child_path
  return GUI.get_node("Head%s" % child_path)

func get_foot(child_path:="") -> HBoxContainer:
  if child_path and child_path[0] != '/':
    child_path = "/%s" % child_path
  return GUI.get_node("Foot%s" % child_path)
