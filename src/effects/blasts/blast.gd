"""
filename: blast.gd
"""

extends Node

const BlastCone = preload("cone.gd")

const MAX_DUR = 1.0 # seconds
# multiplied by seconds charged, deefines the ratio of force/sec
const POWER_SCALE = 200.0
#
const LEN_SCALE = 3.0

var arm = null
var power = 0.0
var dir = Vector2()

var origin = Vector2()
var cone = null

var elapsed = 0.0 # seconds

func _ready():
  $Cone.enable()

func build_cone(arm, charge, launch_dir):
  self.arm = arm
  self.power = charge * POWER_SCALE
  self.dir = launch_dir
  # DEV NOTE I _think_ this position should be local to the parent,
  # rather than a global position, but if Blast is always a child of
  # Level I think both shoud be equal?
  self.origin = arm.get_global_firing_pos() # - get_parent().global_position

  $Cone.setup(
    origin, dir,
    # how long the cone will be; we want length to scale with power, but straight
    # power is too big (often over 9-- I mean, over 1000)
    # the arm itself can modulate length, but we keep a local constant for scaling as well
    power * arm.CONE_LENGTH / LEN_SCALE,
    arm.CONE_ARC, arm.CONE_WIDTH
  )

  # TODO connect collision logic from cone to self

  # the proportional propulsive power of the blast
  # we don't want the difference to be too big, so we scale it down a bit
  var proportion = 1.0 + (1.0 - $Cone.avg_len) / LEN_SCALE

  # return the pushing force of the blast
  return power * proportion

func _physics_process(dt):
  elapsed += dt
  if elapsed >= MAX_DUR:
    self.queue_free()
