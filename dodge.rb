require 'ruby2d'
require_relative 'lib/math_2d'
require_relative 'lib/ruby2d_extras'

set(title: "Dodge", width: 400, height: 500, fps: 100)

$width = Window.width
$height = Window.height
$started = false
$restart = false
$gravity = 490

class Background
    def initialize(x)
        @x = x
        @vel_x = 80
    end

    def update(time)
        if($started)
            if(@image1 && (@x <= -@image1.width))
                @x = 0
            end
            @x -= @vel_x * time
        end
    end

    def show
        @image1 = Image.new('assets/bg.png', x: @x, y: 0, width: 640, height: 640)
        @image2 = Image.new('assets/bg.png', x: @x + @image1.width, y: 0, width: 640, height: 640)
    end
end

class Player

    attr_reader :width, :height
    attr_accessor :pos, :vel, :thrust, :dead

    def initialize(pos)
        @pos = pos
        @vel = Vector2D.new(0, 0)
        @thrust = 495

        @width = 35
        @height = 62
        @dead = false
    end

    def update(time)
        if($started)
            @vel.y += $gravity
            @vel.y = Utils2D.constrain(@vel.y, -490.0, 500)
            @pos = @pos.add(@vel.mult(time))
            @pos.y = Utils2D.constrain(@pos.y, 0, $width + 124)

            if(@pos.y >= $width + 62)
                @dead = true
            end
        end
    end

    # http://www.jeffreythompson.org/collision-detection/circle-rect.php
    def collide(asteroid)
        cx = asteroid.pos.x + asteroid.radius
        cy = asteroid.pos.y + (asteroid.height / 2)

        test_x = cx
        test_y = cy

        if(cx < @pos.x)
            test_x = @pos.x
        elsif(cx > @pos.x + @width)
            test_x = @pos.x + @width
        end
        if(cy < @pos.y)
            test_y = @pos.y
        elsif(cy > @pos.y + @height)
            test_y = @pos.y
        end

        dist_x = cx - test_x
        dist_y = cy - test_y
        distance = Math.sqrt((dist_x * dist_x) + (dist_y * dist_y))

        if(distance <= asteroid.radius)
            @dead = true
        end
    end

    def show
        if(@vel.y < 0.0)
            angle = 10
        elsif(@vel.y > 0.0)
            angle = -10
        else
            angle = Utils2D.lerp(10, -10, @vel.y)
        end
        Image.new('assets/ziggy.png', x: @pos.x, y: @pos.y, width: 35, height: 62, rotate: angle)
    end
end

class Asteroids
    
    attr_reader :width, :height, :radius
    attr_accessor :pos, :vel

    def initialize(pos)
        @pos = pos
        @vel = Vector2D.new(rand(-500..-100), 0)
        @angle = rand(0..360)

        @width = 64
        @height = 64
        @radius = 32
    end

    def update(time)
        if($started)
            @angle += @vel.x * time
            @pos.x += @vel.x * time
        end
    end

    def show
        @sprite = Image.new('assets/asteroid.png', x: @pos.x, y: @pos.y, width: 64, height: 64, rotate: @angle)
    end
end

background = Background.new(0)
player = Player.new(Vector2D.new(70, 100))
asteroids = []
jetpack = []
trail = []

score = 0

on :key_down do |event|
    case event.key
    when 'space'
        if(!player.dead && !$started)
            $started = true
        elsif(player.dead && $started)
            $started = false
            clear()
            player.pos.y = 100
            score = 0
            player.dead = false
            asteroids.clear
            jetpack.clear
            trail.clear
            $started = true
        end
    end
end

on :key_held do |event|
    case event.key
    when 'space'
        if($started && !player.dead)
            player.vel.y -= player.thrust
            if(player.vel.y < 0.0)
                player.vel.y -= player.thrust * 1.25
            end
        end
    end
end

# Dear God, I don't know how I managed to write so many IFs.
# TODO: I need to refactor this ASAP.
update do
    clear()

    elapsed_time = 1 / Window.fps

    if($started)
        if(asteroids.length <= 2)
            asteroids.push(Asteroids.new(Vector2D.new($width, rand(-32..($height - 32)))))
        end
    end

    if($started && !player.dead)
        score += elapsed_time
    end

    if(!player.dead)
        background.update(elapsed_time)
    end
    background.show

    trail.each do |t|
        t.update(elapsed_time)
        if(!t.active?)
            trail.delete(t)
        end
        t.show
    end

    asteroids.each do |asteroid|
        if(asteroid.pos.x < -asteroid.width)
            asteroids.delete(asteroid)
        end
        for c in 0...3
            trail.push(Particle.new(x: asteroid.pos.x + (asteroid.width / 2), y: rand((asteroid.pos.y + (asteroid.height / 2) - 5)..(asteroid.pos.y + (asteroid.height / 2)) + 5),
                                    vx: 2.5, vy: 0,
                                    color1: [0.67, 0.84, 0.96, 1.0],
                                    color2: [0.14, 0.36, 0.53, 1.0],
                                    size1: 28,
                                    size2: 2,
                                    lifetime: 0.5))
        end
        asteroid.update(elapsed_time)
        asteroid.show
        player.collide(asteroid)
    end

    player.update(elapsed_time)
    player.show

    if(!$started && !player.dead)
        Text.new("Press SPACE", x: 50, y: ($width / 2), size: 50, color: "orange")
    end

    if($started && player.dead)
        Text.new("Press SPACE to RESTART", x: 20, y: ($width / 2) + 30, size: 30, color: "orange")
        Text.new("Your score was #{score.to_i}", x: ($width / 2) - 60, y: ($width / 2) + 70, size: 15, color: "orange")
    end

    if($started && !player.dead)

        Text.new("#{score.to_i}", x: ($width / 2) - 10, y: 30, size: 20, color: 'white')

        for c in 0...1
            jetpack.push(Particle.new(x: rand(70..72), y: player.pos.y + 53,
                                        vx: -0.25, vy: rand(0.5..2.5),
                                        color1: [0.52, 0.38, 0.68, 1.0],
                                        color2: [0.77, 0.62, 0.84, 1.0],
                                        size1: rand(2.0..6.0),
                                        size2: rand(2.0),
                                        lifetime: 0.5,
                                        shape: :circle))
        end

        if(player.vel.y < 490.0)
            jetpack.each do |jet|
                jet.update(elapsed_time)
                if (!jet.active?)
                    jetpack.delete(jet)
                end
                jet.show
            end
        end
    end

end

show()