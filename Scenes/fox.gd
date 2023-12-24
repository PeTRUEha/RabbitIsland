extends CharacterBody2D

enum{
	JUMPING,
	WALKING,
	DIGGING
}
var state = WALKING

const run_speed = 200
var is_user_input_blocked: bool = false
var is_jumping: bool = false
var direction: Vector2
var nearby_hole: RabbitHole
var digging_time = 2.4

@export var speed: float

func _ready():
	pass # Replace with function body.

func _process(_delta):
	process_user_input()
	velocity = direction * speed
	adjust_sprite()
	move_and_slide()
			
func process_user_input():	
	if is_user_input_blocked:
		return
	direction = Input.get_vector("Left", "Right", "Up", "Down")			
	
	if (Input.is_action_pressed("Attack") and direction == Vector2.ZERO
		and nearby_hole and nearby_hole.digable):
		start_dig()
	elif Input.is_action_pressed("Attack"):
		start_jump()
		state = JUMPING
	
	if state == WALKING:
		speed = run_speed
		if direction == Vector2(0, 0):
			$AnimationPlayer.play("idle")
		else :
			$AnimationPlayer.play("walking")
		

func adjust_sprite():
	if direction.x > 0:
		$Sprite2D.flip_h = false
	elif direction.x < 0:
		$Sprite2D.flip_h = true
		
func start_jump():
	speed = velocity.length()
	direction = velocity.normalized()
	$AnimationPlayer.play("jump")
	
func end_jump():
	state=WALKING
	unblock_user_input()

func start_dig():
	state = DIGGING
	$AnimationPlayer.play("digging")
	is_user_input_blocked = true
	create_tween().tween_callback(end_dig).set_delay(digging_time)
	
	
func end_dig():
	state = WALKING
	is_user_input_blocked = false
	nearby_hole.be_digged()


func attack_area():
	var preys_hit: Array = $AttackArea.get_overlapping_bodies()
	for prey in preys_hit:
		if prey.has_method("die"):
			prey.die()

func block_user_input(duration: float = 1000):
	is_user_input_blocked=true
	$Timer.connect("timeout", unblock_user_input)
	$Timer.set_wait_time(duration)
	$Timer.start()
	
func unblock_user_input():
	is_user_input_blocked=false


func _on_attack_area_body_entered(body: RabbitHole):
	nearby_hole = body


func _on_attack_area_body_exited(body: RabbitHole):
	nearby_hole = null
