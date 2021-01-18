require 'ruby2d'
require_relative 'lib/math_2d'
require_relative 'lib/ruby2d_extras'

set(title: "Dodge", width: 400, height: 500, fps: 100)

$width = Window.width
$height = Window.height
$started = false
$restart = false
$gravity = 490

jetpack = []

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

    def collide(asteroid)
        if(@pos.x < asteroid.pos.x + asteroid.width &&
           @pos.x + @width > asteroid.pos.x &&
           @pos.y < asteroid.pos.y + asteroid.height &&
           @pos.y + @height > asteroid.pos.y)

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
    
    attr_reader :width, :height
    attr_accessor :pos

    def initialize(pos)
        @pos = pos
        @vel = Vector2D.new(rand(-500..-100), 0)

        @width = 64
        @height = 64
    end

    def update(time)
        if($started)
            @pos.x += @vel.x * time
        end
    end

    def show
        Image.new('assets/asteroid.png', x: @pos.x, y: @pos.y, width: 64, height: 64)
    end
end

background = Background.new(0)
player = Player.new(Vector2D.new(70, 100))
asteroids = []

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

update do
    clear()

    elapsed_time = 1 / Window.fps

    if($started)
        if(asteroids.length <= 2)
            asteroids.push(Asteroids.new(Vector2D.new($width, rand(-64..($height - 32)))))
        end
    end

    if($started && !player.dead)
        score += elapsed_time
    end

    if(!player.dead)
        background.update(elapsed_time)
    end
    background.show

    player.update(elapsed_time)
    player.show
    asteroids.each do |asteroid|
        if(asteroid.pos.x < -asteroid.width)
            asteroids.delete(asteroid)
        end
        asteroid.update(elapsed_time)
        asteroid.show
        player.collide(asteroid)
    end

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