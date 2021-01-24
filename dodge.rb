require 'ruby2d'
require_relative 'lib/math_2d'
require_relative 'lib/ruby2d_extras'

set(title: "Dodge", width: 256, height: 240, fps: 30, fullscreen: true)

$width = Window.width
$height = Window.height
$started = false
$restart = false
$gravity = 190

class Background
    def initialize(x)
        @x = x
        @vel_x = 30
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
        @image1 = Image.new('assets/bg.png', x: @x, y: 0, width: 256, height: 256)
        @image2 = Image.new('assets/bg.png', x: @x + @image1.width, y: 0, width: 256, height: 256)
    end
end

class Player

    attr_reader :width, :height
    attr_accessor :pos, :vel, :thrust, :dead

    def initialize(pos)
        @pos = pos
        @vel = Vector2D.new(0, 0)
        @thrust = 200

        @width = 18
        @height = 28
        @dead = false
    end

    def update(time)
        if($started)
            @vel.y += $gravity
            @vel.y = Utils2D.constrain(@vel.y, -190, 200)
            @pos = @pos.add(@vel.mult(time))
            @pos.y = Utils2D.constrain(@pos.y, 0, $width + 32)

            if(@pos.y >= $width + 28)
                @dead = true
            end
        end
    end

    # http://www.jeffreythompson.org/collision-detection/circle-rect.php
    def collide(asteroid)
        cx = asteroid.pos.x + (asteroid.width / 2)
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

        if(distance <= (asteroid.width / 2))
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
        Image.new('assets/ziggy.png', x: @pos.x, y: @pos.y, width: 18, height: 28, rotate: angle)
    end
end

class Asteroids
    
    attr_reader :width, :height
    attr_accessor :pos, :vel

    def initialize(pos, width, height)
        @pos = pos
        @vel = Vector2D.new(rand(-350..-50), 0)
        @angle = rand(0..360)

        @width = width
        @height = height
    end

    def update(time)
        if($started)
            @angle += @vel.x * time
            @pos.x += @vel.x * time
        end
    end

    def show
        @sprite = Image.new('assets/asteroid.png', x: @pos.x, y: @pos.y, width: @width, height: @height, rotate: @angle)
    end
end

background = Background.new(0)
player = Player.new(Vector2D.new(50, 100))
asteroids = []
jetpack = []
trail = []

song = Music.new("assets/theme.wav")
song.volume = 50
song.loop = true
song.play

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
            size = rand(16..32)
            asteroids.push(Asteroids.new(Vector2D.new($width + 100, rand(-8..($height - 16))), size, size))
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
            trail.push(Particle.new(x: asteroid.pos.x + (asteroid.width / 4), y: rand((asteroid.pos.y + (asteroid.height / 2) - (asteroid.height / 4))..(asteroid.pos.y + (asteroid.height / 2)) + (asteroid.height / 4)),
                                    vx: 2.5, vy: 0,
                                    color1: [0.67, 0.84, 0.96, 1.0],
                                    color2: [0.14, 0.36, 0.53, 1.0],
                                    size1: Utils2D.map(asteroid.width, 16, 32, 6, 12),
                                    size2: 2,
                                    lifetime: 0.5,
                                    shape: :square))
        end
        asteroid.update(elapsed_time)
        asteroid.show
        player.collide(asteroid)
    end

    player.update(elapsed_time)
    player.show

    if(!$started && !player.dead)
        Text.new("Press SPACE", x: 27, y: ($width / 2), size: 25, font: "assets/PixelEmulator.ttf", color: "orange")
    end

    if($started && player.dead)
        Text.new("Press SPACE to RESTART", x: 14, y: $width / 2, size: 14, font: "assets/PixelEmulator.ttf", color: "orange")
        Text.new("Your score was #{score.to_i}", x: ($width / 2) - 60, y: ($width / 2) + 20, size: 10, font: "assets/PixelEmulator.ttf", color: "orange")
    end

    if($started && !player.dead)

        Text.new("#{score.to_i}", x: ($width / 2) - 10, y: 15, size: 15, font: "assets/PixelEmulator.ttf", color: 'white')

        for c in 0...1
            jetpack.push(Particle.new(x: rand(49..51), y: player.pos.y + 30,
                                        vx: -0.25, vy: rand(0.5..2.5),
                                        color1: [0.52, 0.38, 0.68, 1.0],
                                        color2: [0.77, 0.62, 0.84, 1.0],
                                        size1: rand(2.0..6.0),
                                        size2: rand(2.0),
                                        lifetime: 0.5,
                                        shape: :square))
        end

        if(player.vel.y < 300.0)
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