interface Bunny {
	sprite: godot.Sprite;
	pos: godot.Vector2;
}

export default class BunnymarkV1Sprites extends godot.Node2D {
	private bunnies: Bunny[] = [];
	private grav = 500;
	private bunny_texture = godot.ResourceLoader.load("res://images/godot_bunny.png") as godot.Texture;
	private screen_size: godot.Vector2 = null;

	_process(delta: number) {
		this.screen_size = this.get_viewport_rect().size;
		
		for (let bunny of this.bunnies) {
			let pos = bunny.sprite.position;
			let newPosition = bunny.pos;
			
			pos.x += newPosition.x * delta;
			pos.y += newPosition.y * delta;
			newPosition.y += this.grav * delta;
		
			if (pos.x > this.screen_size.x) {
				newPosition.x *= -1;
				pos.x = this.screen_size.x;
			}
			
			if (pos.x < 0) {
				newPosition.x *= -1;
				pos.x = 0;
			}
				
			if (pos.y > this.screen_size.y) {
				pos.y = this.screen_size.y;
				if (Math.random() > 0.5)
					newPosition.y = -(godot.randi() % 1100 + 50);
				else
					newPosition.y *= -0.85;
			}
				
			if (pos.y < 0) {
				newPosition.y = 0;
				pos.y = 0;
			}
			
			bunny.sprite.position = pos;
			bunny.pos = newPosition;
		}
	}
	
	add_bunny() {
		let bunny = new godot.Sprite();
		bunny.set_texture(this.bunny_texture);
		this.add_child(bunny);
		bunny.position = new godot.Vector2(this.screen_size.x / 2, this.screen_size.y / 2);
		this.bunnies.push({
			sprite: bunny,
			pos: new godot.Vector2(godot.randi() % 200 + 50, godot.randi() % 200 + 50)
		});
	}
	
	remove_bunny() {
		if (this.bunnies.length == 0)
			return;
		this.remove_child(this.bunnies.pop().sprite);
	}
	
	finish() {
		this.emit_signal("benchmark_finished", this.bunnies.length);
	}

}

godot.register_class(BunnymarkV1Sprites, "BunnymarkV1Sprites");