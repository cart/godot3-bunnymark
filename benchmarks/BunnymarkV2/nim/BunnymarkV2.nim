import random
import godot, engine
import node_2d, texture, sprite, viewport, label, resource_loader

gdobj BunnymarkV2 of Node2d:
    var texture: Texture = Texture(load("res://images/godot_bunny.png"))
    var speeds: seq[Vector2] = @[]
    var label: Label = gdnew[Label]()
    var bunnies: Node2D = gdnew[Node2D]()
    var screenSize: Vector2
    var gravity: float = 500.0
    
    method ready*() =
        self.addChild(self.bunnies)
        self.label.rectPosition = vec2(0.0,20.0)
        self.addChild(self.label)
        self.setProcess(true)

    method process*(delta: float64) =
        self.screenSize = self.getViewportRect().size
        self.label.text = "Bunnies: " & $self.bunnies.getChildCount()

        var bunnyChildren = self.bunnies.getChildren()
        for i in 0..<bunnyChildren.len():
            var bunny = cast[Sprite](bunnyChildren[i])
            var position = bunny.position
            var speed = self.speeds[i]

            position.x += speed.x * delta
            position.y += speed.y * delta

            speed.y += self.gravity * delta

            if position.x > self.screenSize.x:
                speed.x *= -1
                position.x = self.screenSize.x
            
            if position.x < 0:
                speed.x *= -1
                position.x = 0
            
            if position.y > self.screenSize.y:
                position.y = self.screenSize.y
                if (random(1.0) > 0.5):
                    speed.y = (random(1100.0) + 50.0)
                else:
                    speed.y *= -0.85
            
            if position.y < 0:
                speed.y = 0
                position.y = 0
            
            bunny.position = position
            self.speeds[i] = speed

    proc addBunny*() {.gdExport.} =
        let bunny = gdnew[Sprite]()
        bunny.texture = self.texture
        self.bunnies.addChild(bunny)
        bunny.position = vec2(self.screenSize.x / 2, self.screenSize.y / 2)
        self.speeds.add(vec2(random(200.0) + 50.0, random(200.0) + 50.0))
    
    proc removeBunny*() {.gdExport.} =
        var childCount = self.bunnies.getChildCount()
        if childCount == 0:
            return
        var bunny = self.bunnies.getChild(childCount - 1)
        var speed = self.speeds.pop()
        self.bunnies.removeChild(bunny)
    
    proc finish*() {.gdExport.} =
        self.emitSignal("benchmark_finished", @[newVariant(self.bunnies.getChildCount())])