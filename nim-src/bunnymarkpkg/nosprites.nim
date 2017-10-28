import random
import godot, engine
import node_2d, texture, sprite, viewport, label

gdobj NoSpriteBenchmark of Node2d:
    var texture* {.gdExport.}: Texture
    var bunnies: seq[tuple[position: Vector2, motion: Vector2]] = @[]
    var screen: Vector2
    var viewport: Viewport
    var elapsed: float = 0.0
    var grav: float = 500.0
    
    method ready*() =
        viewport = getViewport()
        screen = viewport.size()
        discard getNode("../gui/list/add").connect("pressed", self, "add_bunnies", newArray())
        for _ in 1..10:
            addBunny()
        (getNode("../gui/list/count") as Label).text = "Bunny count: " & $bunnies.len
        setProcess(true)
    
    method draw*() =
        for bunny in bunnies.items:
            drawTexture(texture, bunny.position, normalMap = texture)

    method process*(delta: float64) =
        elapsed += delta
        screen = viewport.size()
        if elapsed > 1:
            (getNode("../gui/list/fps") as Label).text = "FPS: " & $getFramesPerSecond()
            elapsed = 0

        for bunny in bunnies.mitems:
            var position = bunny.position
            var motion = bunny.motion

            position.x += motion.x * delta
            position.y += motion.y * delta

            motion.y += grav * delta

            if position.x > screen.x:
                motion.x *= -1
                position.x = screen.x
            
            if position.x < 0:
                motion.x *= -1
                position.x = 0
            
            if position.y > screen.y:
                position.y = screen.y
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

    proc addBunny*() =
        bunnies.add((vec2(screen.x / 2, screen.y / 2), vec2(random(200.0) + 50.0, random(200.0) + 50.0)))
    
    proc addBunnies*() {.gdExport.} =
        for _ in 1..100:
            addBunny()
        (getNode("../gui/list/count") as Label).text = "Bunny count: " & $bunnies.len