extends CharacterBody2D

const HORIZONTAL_SPEED = 100.0
const BOUNCE_VELOCITY = -400.0

func _ready() -> void:
	# Start moving right (or left)
	velocity.x = HORIZONTAL_SPEED

func _physics_process(delta: float) -> void:
	# Apply gravity
	velocity += get_gravity() * delta

	# Move and check for collisions
	var collision := move_and_collide(velocity * delta)
	if collision:
		var normal := collision.get_normal()
		var collider := collision.get_collider()

		# 1. Hit a left or right wall -> flip horizontal direction
		if abs(normal.x) > 0.7:
			velocity.x = -velocity.x

		# 2. Landed on top of something (umbrella / player or floor)
		if normal.y < -0.5:
			velocity.y = BOUNCE_VELOCITY

			# Optional: angle the bounce depending on where the cat hits the umbrella
			if collider.name == "player":
				var offset: float = global_position.x - collider.global_position.x
				velocity.x = clamp(offset * 4.0, -HORIZONTAL_SPEED, HORIZONTAL_SPEED)
				if abs(velocity.x) < 20.0:
					velocity.x = HORIZONTAL_SPEED * sign( offset if offset != 0 else 1.0 )
