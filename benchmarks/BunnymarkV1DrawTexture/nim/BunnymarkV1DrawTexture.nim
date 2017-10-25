import random
import godot, engine
import node_2d, texture, sprite, viewport, label, resource_loader

gdobj BunnymarkV1DrawTexture of Node2d:
    var texture: Texture = Texture(load("res://images/godot_bunny.png"))
    var bunnies: seq[tuple[position: Vector2, motion: Vector2]] = @[]
    var gravity: float = 500.0
    var screenSize: Vector2
    
    method ready*() =
        setProcess(true)

    method draw*() =
        for bunny in bunnies:
            drawTexture(texture, bunny.position, normalMap=texture)

    method process*(delta: float64) =
        screenSize = getViewportRect().size

        for bunny in bunnies.mitems:
            var position = bunny.position
            var motion = bunny.motion

            position.x += motion.x * delta
            position.y += motion.y * delta

            motion.y += gravity * delta

            if position.x > screenSize.x:
                motion.x *= -1
                position.x = screenSize.x
            
            if position.x < 0:
                motion.x *= -1
                position.x = 0
            
            if position.y > screenSize.y:
                position.y = screenSize.y
                if (random(1.0) > 0.5):
                    motion.y = (random(1100.0) + 50.0)
                else:
                    motion.y *= -0.85
            
            if position.y < 0:
                motion.y = 0
                position.y = 0
            
            bunny.position = position
            bunny.motion = motion
        update()

    proc addBunny*() {.gdExport.} =
        bunnies.add((vec2(screenSize.x / 2, screenSize.y / 2), vec2(random(200.0) + 50.0, random(200.0) + 50.0)))
    
    proc removeBunny*() {.gdExport.} =
        if bunnies.len == 0:
            return

        var bunny = bunnies.pop()
    
    proc finish*() {.gdExport.} =
        emitSignal("benchmark_finished", @[newVariant(bunnies.len)])