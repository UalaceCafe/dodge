require 'ruby2d'
require_relative 'math_2d'

module Ruby2D
    class Quad
        include Renderable

        attr_reader :angle

        def rotate(x_pivot, y_pivot, angle)
            @angle = (Math::PI * angle) / 180
        
            x_shifted1 = @x1 - x_pivot
            y_shifted1 = @y1 - y_pivot
            x_shifted2 = @x2 - x_pivot
            y_shifted2 = @y2 - y_pivot
            x_shifted3 = @x3 - x_pivot
            y_shifted3 = @y3 - y_pivot
            x_shifted4 = @x4 - x_pivot
            y_shifted4 = @y4 - y_pivot
        
            @x1 = x_pivot + (x_shifted1 * Math.cos(@angle) - y_shifted1 * Math.sin(@angle))
            @y1 = y_pivot + (x_shifted1 * Math.sin(@angle) + y_shifted1 * Math.cos(@angle))
        
            @x2 = x_pivot + (x_shifted2 * Math.cos(@angle) - y_shifted2 * Math.sin(@angle))
            @y2 = y_pivot + (x_shifted2 * Math.sin(@angle) + y_shifted2 * Math.cos(@angle))
        
            @x3 = x_pivot + (x_shifted3 * Math.cos(@angle) - y_shifted3 * Math.sin(@angle))
            @y3 = y_pivot + (x_shifted3 * Math.sin(@angle) + y_shifted3 * Math.cos(@angle))
        
            @x4 = x_pivot + (x_shifted4 * Math.cos(@angle) - y_shifted4 * Math.sin(@angle))
            @y4 = y_pivot + (x_shifted4 * Math.sin(@angle) + y_shifted4 * Math.cos(@angle))
        end

        def angle=(angle)
            @angle = angle
            rotate(@x, @y, angle)
        end
    end

    class Triangle
        include Renderable

        attr_reader :angle

        def rotate(x_pivot, y_pivot, angle)
            @angle = (Math::PI * angle) / 180
        
            x_shifted1 = @x1 - x_pivot
            y_shifted1 = @y1 - y_pivot
            x_shifted2 = @x2 - x_pivot
            y_shifted2 = @y2 - y_pivot
            x_shifted3 = @x3 - x_pivot
            y_shifted3 = @y3 - y_pivot
        
            @x1 = x_pivot + (x_shifted1 * Math.cos(@angle) - y_shifted1 * Math.sin(@angle))
            @y1 = y_pivot + (x_shifted1 * Math.sin(@angle) + y_shifted1 * Math.cos(@angle))
        
            @x2 = x_pivot + (x_shifted2 * Math.cos(@angle) - y_shifted2 * Math.sin(@angle))
            @y2 = y_pivot + (x_shifted2 * Math.sin(@angle) + y_shifted2 * Math.cos(@angle))
        
            @x3 = x_pivot + (x_shifted3 * Math.cos(@angle) - y_shifted3 * Math.sin(@angle))
            @y3 = y_pivot + (x_shifted3 * Math.sin(@angle) + y_shifted3 * Math.cos(@angle))
        end

        def angle=(angle)
            @angle = angle
            rotate(@x, @y, angle)
        end
    end

    class Line
        include Renderable

        attr_reader :angle

        def rotate(x_pivot, y_pivot, angle)
            @angle = (Math::PI * angle) / 180
        
            x_shifted1 = @x1 - x_pivot
            y_shifted1 = @y1 - y_pivot
            x_shifted2 = @x2 - x_pivot
            y_shifted2 = @y2 - y_pivot
        
            @x1 = x_pivot + (x_shifted1 * Math.cos(@angle) - y_shifted1 * Math.sin(@angle))
            @y1 = y_pivot + (x_shifted1 * Math.sin(@angle) + y_shifted1 * Math.cos(@angle))
        
            @x2 = x_pivot + (x_shifted2 * Math.cos(@angle) - y_shifted2 * Math.sin(@angle))
            @y2 = y_pivot + (x_shifted2 * Math.sin(@angle) + y_shifted2 * Math.cos(@angle))
        end

        def angle=(angle)
            @angle = angle
            rotate(@x, @y, angle)
        end
    end

    class Circle
        include Renderable

        attr_reader :angle

        def rotate(x_pivot, y_pivot, angle)
            @angle = (Math::PI * angle) / 180
        
            x_shifted = @x - x_pivot
            y_shifted = @y - y_pivot
        
            @x = x_pivot + (x_shifted * Math.cos(@angle) - y_shifted * Math.sin(@angle))
            @y = y_pivot + (x_shifted * Math.sin(@angle) + y_shifted * Math.cos(@angle))
        end

        def angle=(angle)
            @angle = angle
            rotate(@x, @y, angle)
        end
    end

    # Creates a non-filled circle using the Midpoint Circle Algorithm
    # For reference:
    #   https://en.wikipedia.org/wiki/Midpoint_circle_algorithm
    #
    # `width` is the thickness of the border
    #
    # TODO: `contains?` method
    class NoFillCircle

        include Renderable

        attr_accessor :x, :y, :z, :radius, :color, :c1, :c2, :c3, :c4

        def initialize(opts = {})
            @x = opts[:x] || 25
            @y = opts[:y] || 25
            @z = opts[:z] || 0
            @radius = opts[:radius] || 25
            @width = opts[:width] || 2
            self.opacity = opts[:opacity] if opts[:opacity]

            xi = @radius
            yi = 0
            @points = []
            @points.push(Circle.new(x: xi + @x, y: yi + @y, z: @z, radius: @width))
            if(@radius > 0)
                @points.push(Circle.new(x: xi + @x, y: -yi + @y, z: @z, radius: @width))
                @points.push(Circle.new(x: yi + @x, y: xi + @y, z: @z, radius: @width))
                @points.push(Circle.new(x: -yi + @x, y: xi + @y, z: @z, radius: @width))
            end
            point = 1 - @radius
            while(xi > yi)
                yi += 1
                if(point <= 0)
                    point = point + 2 * yi + 1
                else
                    xi -= 1
                    point = point + 2 * yi - 2 * xi + 1
                end
                if(xi < yi)
                    break
                end
                @points.push(Circle.new(x: xi + @x, y: yi + @y, z: @z, radius: @width))
                @points.push(Circle.new(x: -xi + @x, y: yi + @y, z: @z, radius: @width))
                @points.push(Circle.new(x: xi + @x, y: -yi + @y, z: @z, radius: @width))
                @points.push(Circle.new(x: -xi + @x, y: -yi + @y, z: @z, radius: @width))
                if(xi != yi)
                    @points.push(Circle.new(x: yi + @x, y: xi + @y, z: @z, radius: @width))
                    @points.push(Circle.new(x: -yi + @x, y: xi + @y, z: @z, radius: @width))
                    @points.push(Circle.new(x: yi + @x, y: -xi + @y, z: @z, radius: @width))
                    @points.push(Circle.new(x: -yi + @x, y: -xi + @y, z: @z, radius: @width))
                end
            end
            @points.each do |l|
                @color = l.color = opts[:color] || 'white'
            end
        end

        def color=(c)
            @points.each {|l| l.color = Color.set(c)}
            @points.each {|l| update_color(l.color)}
        end

        def update_color(c)
            if c.is_a? Color::Set
                if c.length == 4
                    @c1 = c[0]
                    @c2 = c[1]
                    @c3 = c[2]
                    @c4 = c[3]
                else
                    raise ArgumentError, "`#{self.class}` requires 4 colors, one for each vertex. #{c.length} were given."
                end
            else
                @c1 = c
                @c2 = c
                @c3 = c
                @c4 = c
            end
        end
    end

    # Creates a non filled square
    #
    # `width` is the thickness of the border
    class NoFillSquare

        include Renderable

        attr_accessor :x, :y, :z, :size, :color, :c1, :c2, :c3, :c4

        def initialize(opts = {})
            @x = opts[:x] || 0
            @y = opts[:y] || 0
            @z = opts[:z] || 0
            @size = opts[:size] || 100
            @width = opts[:width] || 2
            self.opacity = opts[:opacity] if opts[:opacity]

            @lines = []
            @lines.push(Line.new(x1: @x, y1: @y, x2: @x + @size, y2: @y, z: @z, width: @width))
            @lines.push(Line.new(x1: @x + @size, y1: @y, x2: @x + @size, y2: @y + @size, z: @z, width: @width))
            @lines.push(Line.new(x1: @x + @size, y1: @y + @size, x2: @x, y2: @y + @size, z: @z, width: @width))
            @lines.push(Line.new(x1: @x, y1: @y + @size, x2: @x, y2: @y, z: @z, width: @width))

            @lines.each do |l|
                @color = l.color = opts[:color] || 'white'
            end
        end

        def color=(c)
            @lines.each {|l| l.color = Color.set(c)}
            @lines.each {|l| update_color(l.color)}
        end

        def update_color(c)
            if c.is_a? Color::Set
                if c.length == 4
                    @c1 = c[0]
                    @c2 = c[1]
                    @c3 = c[2]
                    @c4 = c[3]
                else
                    raise ArgumentError, "`#{self.class}` requires 4 colors, one for each vertex. #{c.length} were given."
                end
            else
                @c1 = c
                @c2 = c
                @c3 = c
                @c4 = c
            end
        end
    end

    # Creates a Quad shape with a border
    #
    # `b` gives you access to the border shape
    # `f` gives you acess to the inside shape
    #
    # `border` is the border color
    # `fill` is the inside color
    # `size` is the border size
    class FillQuad

        include Renderable

        attr_accessor :x1, :y1, :c1,
                      :x2, :y2, :c2,
                      :x3, :y3, :c3,
                      :x4, :y4, :c4,
                      :b,  :f

        def initialize(opts = {})
            @x1 = opts[:x1] || 0
            @y1 = opts[:y1] || 0
            @x2 = opts[:x2] || 100
            @y2 = opts[:y2] || 0
            @x3 = opts[:x3] || 100
            @y3 = opts[:y3] || 100
            @x4 = opts[:x4] || 0
            @y4 = opts[:y4] || 100
            @size = opts[:size] || 2
            @border = opts[:border] || 'black'
            @fill = opts[:fill] || 'white'
            @z  = opts[:z]  || 0
            self.opacity = opts[:opacity] if opts[:opacity]

            @b = Quad.new(x1: @x1, y1: @y1, x2: @x2, y2: @y2, x3: @x3, y3: @y3, x4: @x4, y4: @y4, z: @z, color: @border, opacity: @opacity)

            x1_a = @x1 + @size
            x2_a = @x2 - @size
            x3_a = @x3 - @size
            x4_a = @x4 + @size
            y1_a = @y1 + @size
            y2_a = @y2 + @size
            y3_a = @y3 - @size
            y4_a = @y4 - @size

            @f = Quad.new(x1: x1_a, y1: y1_a, x2: x2_a, y2: y2_a, x3: x3_a, y3: y3_a, x4: x4_a, y4: y4_a, z: @z, color: @fill, opacity: @opacity)
        end

        def contains?(x, y)
            return @b.contains?(x, y)
        end
    end

    # Creates a Quad shape with a border
    #
    # `border` is the border color
    # `fill` is the inside color
    # `size` is the border size
    # `side` is the side length
    class FillSquare < FillQuad

        include Renderable

        attr_accessor :x, :y, :z, :size, :border, :fill

        def initialize(opts = {})
            @x = opts[:x] || 0
            @y = opts[:y] || 0
            @size = opts[:size] || 2
            @side = opts[:side] || 100
            @border = opts[:border] || 'black'
            @fill = opts[:fill] || 'white'
            @z  = opts[:z]  || 0

            x2 = @x + @side
            y2 = @y
            x3 = x2
            y3 = @y + @side
            x4 = @x
            y4 = y3

            FillQuad.new(x1: @x, y1: @y, x2: x2, y2: y2, x3: x3, y3: y3, x4: x4, y4: y4, z: @z, size: @size, border: @border, fill: @fill, opacity: @opacity)
        end
    end

    # Creates a Quad shape with a border
    #
    # `border` is the border color
    # `fill` is the inside color
    # `size` is the border size
    class FillRectangle < FillQuad

        include Renderable

        attr_accessor :x, :y, :z, :size, :border, :fill

        def initialize(opts = {})
            @x = opts[:x] || 0
            @y = opts[:y] || 0
            @size = opts[:size] || 2
            @width = opts[:with] || 100
            @height = opts[:height] || 50
            @border = opts[:border] || 'black'
            @fill = opts[:fill] || 'white'
            @z  = opts[:z]  || 0

            x2 = @x + @width
            y2 = @y
            x3 = x2
            y3 = @y + @height
            x4 = @x
            y4 = y3

            FillQuad.new(x1: @x, y1: @y, x2: x2, y2: y2, x3: x3, y3: y3, x4: x4, y4: y4, z: @z, size: @size, border: @border, fill: @fill, opacity: @opacity)
        end
    end

    # Creates a Radio button (SHAPE ONLY)
    #
    # To make it functional, you can do the following:
    #
    # Outside the `update` loop, write
    #
    # radio_button = RadioButton.new(x: x position, y: y position, radius: radius value, color: rgb, hex or string color)
    #
    # on :mouse_down do |event|                                                 # Check for mouse events
    #     case event.button                                                     # Check which button was pressed
    #     when :left                                                            # If it was the left button, do the following
    #         contains = radio_button.contains?(Window.mouse_x, Window.mouse_y) # Check if the mouse cursor is on the button
    #         if(contains)                                                      # If it is, activate the button
    #             radio_button.active = radio_button.active? ? false : true
    #         end
    #         if(radio_button.active? && contains)                              # If active, do something
    #             puts "Radio Button ON"
    #         elsif(!radio_button.active? && contains)                          # If inactive, do something else
    #             puts "Radio Button OFF"
    #         end
    #     end
    # end
    #
    # And then, on `update`:
    #
    # update do
    #   c.draw                                                                  # Draws the button on screen
    # end
    #
    # Remember to ONLY test if the button is activated OUTSIDE the update loop, or else your event you
    # be initiated or deactivated every frame!
    class RadioButton

        attr_accessor :x, :y, :active

        def initialize(opts = {})
            @x = opts[:x] || 100
            @y = opts[:y] || 100
            @radius = opts[:radius] || 6
            @color = opts[:color] || 'white'
            @active = false
        end

        def draw
            @outer = NoFillCircle.new(x: @x, y: @y, radius: @radius, width: 1, color: @color)
            if(@active)
                @inner = Circle.new(x: @x, y: @y, radius: @radius / 2, color: @color)
            end
        end

        def active?
            return @active
        end

        def contains?(x, y)
            return ((x - @x) ** 2 + (y - @y) ** 2) < (@radius ** 2)
        end
    end

    # Creates a single particle with varying size and color according to its remaining life time
    #
    # `x` and `y` are coordinates of the origin position of the particle
    # `vx` and `vy` are the velocities of the particle
    # `color1` is the origin color of the particle. It MUST be a RGB array like [0..1, 0..1, 0..1, 0..1].
    # `color2` is the final color of the particle. As its remaining life decreases, it goes from color1 to color2.
    # `size1` is the origin radius of the particle.
    # `size2` is the final radius of the particle.
    # `lifetime` is how long the particle will last before it vanishes. The value itself is dependant on the timestep
    #            you choose for the `update` method of this class. For example, if you write `update(0.01)`, each time
    #            that method is called the remaining life of the particle will be subtracted by 0.01
    # `shape` is, as the name suggests, the shape of the particle. For now, there's only support for :circle, :square
    # and :triangle (which are just circles with 4 and 3 sectors respectively instead of 10 lol). Default is a circle.
    #
    # One example of usage would be:
    #
    # particles = []
    #
    # for i in 0...100 # This is a very intensive and sub-optimized implementation, so you should limit the number of
    #                  # particles to a maximum of 500
    #
    #     particles.push(Particle.new(x: Window.width / 2, 
    #                                 y: Window.height / 2,
    #                                 vx: rand(-1.0..1.0),
    #                                 vy: rand(-1.0..1.0),
    #                                 color1: [0.99, 0.83, 0.48, 1.0],
    #                                 color2: [0.99, 0.74, 0.16, 1.0],
    #                                 size1: rand(2.0..10.0),
    #                                 size2: rand(2.0),
    #                                 lifetime: 20.0,
    #                                 shape: :circle))
    # end
    #
    # update do
    #   clear()
    #   particles.each do |particle|
    #       particle.update(0.1) # Anything above this is too fast, honestly
    #       if (!particle.active?)
    #           particles.delete(particle)
    #       end
    #       particle.show
    #   end
    # end
    #
    # For a continuous flow of particles, put the for loop inside `update`, but with MUCH less
    # iterations (about 5 particles per frame is more than enough)
    class Particle

        attr_accessor :x, :y, :vx, :vy, :color1, :color2, :size1, :size2, :lifetime, :life_remaining, :active

        def initialize(opts = {})
            @x = opts[:x] || 0
            @y = opts[:y] || 0
            @vx = opts[:vx] || 1.0
            @vy = opts[:vy] || 1.0
            @color1 = opts[:color1] || [1.0, 1.0, 1.0, 1.0]
            @color2 = opts[:color2] || @color1
            @size1 = opts[:size1] || 8
            @size2 = opts[:size2] || 3
            @lifetime = opts[:lifetime] || 1.0
            @shape = opts[:shape] || :circle

            @life_remaining = @lifetime
            @active = true
        end

        def update(ts = 0.01)
            if(@life_remaining <= 0.0)
                @active = false
            end
            @life_remaining -= ts
            @x += @vx
            @y += @vy
        end

        def active?
            return @active
        end
        
        def show
            life = @life_remaining / @lifetime
            r = Utils2D.map(@life_remaining, 0.0, @lifetime, @size2, @size1)
            c1 = Utils2D.lerp(@color2[0], @color1[0], life)
            c2 = Utils2D.lerp(@color2[1], @color1[1], life)
            c3 = Utils2D.lerp(@color2[2], @color1[2], life)
            c4 = Utils2D.lerp(@color2[3], @color1[3], life)
            if(@shape == :circle)
                Circle.new(x: @x, y: @y, radius: r, sectors: 10, opacity: @life_remaining, color: [c1, c2, c3, c4])
            elsif(@shape == :square)
                Circle.new(x: @x, y: @y, radius: r, sectors: 4, opacity: @life_remaining, color: [c1, c2, c3, c4])
            elsif(@shape == :triangle)
                Circle.new(x: @x, y: @y, radius: r, sectors: 3, opacity: @life_remaining, color: [c1, c2, c3, c4])
            end
        end
    end
end