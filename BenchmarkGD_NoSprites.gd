extends Node2D

export(Texture) var t_bunny

var bunnies = []
var grav = 500
var screen_size
var elapsed = 0

func _ready():
	screen_size = get_viewport_rect().size
	get_node("../gui/list/add").connect("pressed", self, "add_bunnies")
	
	for i in range(10): add_bunny()


func _draw():
	for bunny in bunnies:
		draw_texture(t_bunny, bunny[0])
	

func _process(delta):
	elapsed = elapsed + delta
	screen_size = get_viewport_rect().size
	if elapsed > 1:
		get_node('../gui/list/fps').set_text('FPS: ' + str(Engine.get_frames_per_second()))
		elapsed = 0
	
	for bunny in bunnies:
		var pos = bunny[0]
		var newPosition = bunny[1]
		
		pos.x += newPosition.x * delta
		pos.y += newPosition.y * delta
	
		newPosition.y += grav * delta
	
		if pos.x > screen_size.x:
			newPosition.x *= -1
			pos.x = screen_size.x
		
		if pos.x < 0:
			newPosition.x *= -1
			pos.x = 0
			
		if pos.y > screen_size.y:
			pos.y = screen_size.y
			if randf() > 0.5:
				newPosition.y = -(randi() % 1100 + 50)
			else:
				newPosition.y *= -0.85
			
		if pos.y < 0:
			newPosition.y = 0
			pos.y = 0
		
		bunny[0] = pos
		bunny[1] = newPosition
	update()

func add_bunny():
	bunnies.append([Vector2(screen_size.x / 2, screen_size.y / 2), Vector2(randi() % 200 + 50, randi() % 200 + 50)])
	get_node('../gui/list/count').set_text('Bunny count: ' + str(bunnies.size()))

func add_bunnies():
	for i in range(0,100):
		add_bunny()