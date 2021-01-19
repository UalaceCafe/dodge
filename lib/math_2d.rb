#======================================================================#
# >> Based mostly on the P5.js math/vector/etc functions
#----------------------------------------------------------------------#
# An implemention of various math and vector functions from Processing
# and P5.js
#----------------------------------------------------------------------#
# Just a remainder that, apart from the `set` method, every other
# method DOES NOT change the values of the vector, but rather returns
# a new one.
#======================================================================#
class Vector2D

    attr_accessor :x, :y

    # Creates a new vector (x, y)
    def initialize(x, y)
        @x = x
        @y = y
    end

    # Sets the `x` and `y` components of the vector
    # Each argument is optional, so you can change a single component
    # and keep the other one's original value
    def set(x = self.x, y = self.y)
        self.x = x
        self.y = y
    end

    # Adds `self` to another vector or to a scalar
    def add(other)
        if(other.class == Vector2D)
            return Vector2D.new(self.x + other.x, self.y + other.y)
        end
        return Vector2D.new(self.x + other, self.y + other)
    end

    # Subtracts `self` to another vector or to a scalar
    def sub(other)
        if(other.class == Vector2D)
            return Vector2D.new(self.x - other.x, self.y - other.y)
        end
        return Vector2D.new(self.x - other, self.y - other)
    end

    # Multiplies `self` by another vector or by a scalar
    def mult(other)
        if(other.class == Vector2D)
            return Vector2D.new(self.x * other.x, self.y * other.y)
        end
        return Vector2D.new(self.x * other, self.y * other)
    end

    # Divides `self` by another vector or by a scalar
    def div(other)
        if(other.class == Vector2D)
            return Vector2D.new(self.x / other.x, self.y / other.y)
        end
        return Vector2D.new(self.x / other, self.y / other)
    end

    # Calculates the dot product between `self` and `other`, where:
    # A.B (A dot B) = (Ax * Bx) + (Ay * By)
    def dot(other)
        angle = Math.acos((self.x * other.x + self.y * other.y) / (self.magnitude * other.magnitude))
        return self.magnitude * other.magnitude * Math.cos(angle)
    end

    # Calculates the cross product between `self` and `other`, where:
    # AxB (A cross B) = (Ax * By) - (Bx * Ay)
    # However, the cross product is NOT defined in a 2D space, so the operation
    # simply returns the magnitude of the resulting cross-product Vector in 3D
    def cross(other)
        return (self.x * other.y) - (other.x * self.y)
    end

    # Returns the magnitude squared of `self`
    def squared
        return (self.x ** 2) + (self.y ** 2)
    end

    # Returns the magnitude of `self`
    def magnitude
        return Math.sqrt(self.x ** 2 + self.y ** 2)
    end

    # Returns the Euclidean distance between `self` and `other`
    def distance(other)
        return Math.sqrt((other.x - self.x) ** 2 + (other.y - self.y) ** 2)
    end

    # Returns the ratio (x / y) of `self`
    def ratio
        return self.x.to_f / self.y
    end

    # Limit the magnitude of `self` to `max`
    def limit(max)
        msq = self.squared
        vec = self
        if(msq > (max ** 2))
            vec = vec.div(Math.sqrt(msq))
            vec = vec.mult(max)
        end
        return vec
    end

    # Sets the magnitude of `self` to `new_mag`
    def set_magnitude(new_mag)
        mag = self.magnitude
        mag = mag == 0 ? Float::INFINITY : mag
        return Vector2D.new((self.x * new_mag) / mag, (self.y * new_mag) / mag)
    end

    # Normalizes `self` (set the magnitude to 1)
    # `unit` is an alias for this method
    def normalize
        set_magnitude(1)
    end

    alias :unit :normalize

    # Returns true if the magnitude of `self` is equal to 1, false otherwise
    # `unit?` is an alias for this method
    def normalized?
        return self.magnitude == 1
    end

    alias :unit? :normalized?

    # Returns the x-heading angle of `self` in radians
    # The x-heading angle is the angle formed between `self` and the x-axis
    def heading
        return Math.atan2(self.y.to_f, self.x)
    end

    # Returns the y-heading angle of `self` in radians
    # The y-heading angle is the angle formed between `self` and the y-axis
    def y_heading
        return Utils2D::HALF_PI - self.heading
    end

    # Returns a new Vector2D from a given angle `theta` with length `len`
    # By default, `len` = 1
    def self.from_angle(theta, len = 1)
        return Vector2D.new(len * Math.cos(theta), len * Math.sin(theta))
    end

    # Returns the angle between `self` and `other` in radians
    def angle_between(other)
        return Math.acos((self.x * other.x + self.y * other.y) / (self.magnitude * other.magnitude))
    end

    # Rotates `self` `angle` radians and returns it as a new Vector2D
    def rotate(angle)
        return Vector2D.new(self.x * Math.cos(angle) - self.y * Math.sin(angle), self.x * Math.sin(angle) + self.y * Math.cos(angle))
    end

    # Linear interpolate `self` and `other` with an amount `amt`
    def lerp(other, amt)
        self.add(other.sub(self).mult(amt))
    end

    # Reflects `self` and returns it as a new Vector2D
    # `other` is the normal of the plane where `self` is reflected
    def reflect(other)
        self.sub(other.mult(other.dot(self)).mult(2))
    end

    # Returns a new Vector2D with random components but magnitude equal to 1
    def self.random
        theta = rand(-Utils2D::TWO_PI..Utils2D::TWO_PI)
        return Vector2D.new(Math.cos(theta), Math.sin(theta))
    end

    # Converts `self` to an array
    def to_a
        return [self.x, self.y]
    end

    # Converts `self` to a string
    def to_s
        return self.to_a.to_s
    end

    # Returns a new Vector2D from an array `arr`
    # If the array is bigger than 2 elements, only the first 2 will be considered
    def self.to_vector(arr)
        if(arr.class != Array)
            raise ArgumentError, "`arr` must be an Array"
        end
        return Vector2D.new(arr[0], arr[1])
    end
end

module Utils2D

    HALF_PI    = Math::PI / 2
    QUARTER_PI = Math::PI / 4
    TWO_PI     = Math::PI * 2

    # Returns `angle` radians in degrees
    def self.to_deg(angle)
        return (180 * angle) / Math::PI
    end

    # Returns `angle` degrees in radians
    def self.to_rad(angle)
        return (Math::PI * angle) / 180
    end

    # Returns the distance between two cartesian points
    def self.distance(x1, y1, x2, y2)
        return Math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)
    end

    # Calculates a number between two numbers at a specific increment.
    # The amt parameter is the amount to interpolate between the two
    # values where 0.0 equal to the first point, 0.1 is very near the
    # first point, 0.5 is half-way in between, and 1.0 is equal to the
    # second point.
    def self.lerp(a, b, amt)
        return (b - a) * (3.0 - amt * 2.0) * amt * amt + a
    end

    # Re-maps a number from one range to another
    # `a1`...`a2` - first range
    # `b1`...`b2` - second range
    # `value` - the number to be mapped
    def self.map(value, a1, a2, b1, b2)
        if(a2 == a1)
            raise ArgumentError, "Division by 0 - a1 canno't be equal to a2"
        end
        slope = 1.0 * (b2 - b1) / (a2 - a1)
        return b1 + slope * (value - a1)
    end

    # Normalizes a number from another range into a value between 0 and 1
    # `value` - value to normalized
    # `a` - lower limit
    # `b` - upper limit
    def self.normalize(value, a, b)
        return map(value, a, b, 0.0, 1.0)
    end

    # Constrains a value between a minimum and maximum value
    # `x` - value to be constrained
    # `a` - lower limit
    # `b` - upper limit
    def self.constrain(x, a, b)
        return [[x, a].max, b].min
    end

    # Computes the `n`th number from the Fibonacci sequence, starting at index 0
    def self.fib(n)
        # the first 31 fibonacci numbers (0..30)
        cache = [0, 1, 1, 2, 3, 5, 8, 13,
                21, 34, 55, 89, 144, 233,
                377, 610, 987, 1597, 2584,
                4181, 6765, 10946, 17711,
                28657, 46368, 75025, 121393,
                196418, 317811, 514229, 832040]

        if(n < cache.length)
            return cache[n]
        end
        return fib(n - 1) + fib(n - 2)
    end

    # Returns the Perlin noise value at specified coordinates.
    # Perlin noise is a random sequence generator producing a more naturally
    # ordered, harmonic succession of numbers compared to the standard rand() method.
    # The main difference to the rand() method is that Perlin noise is defined in an
    # infinite n-dimensional space where each pair of coordinates corresponds to a fixed
    # semi-random value. Math2D can compute 1D and 2D noise, depending on the number of
    # coordinates given. The resulting value will always be between 0.0 and 1.0.
    def self.noise(x, y = 0)
        x0 = x.to_i
        x1 = x0 + 1
        y0 = y.to_i
        y1 = y0 + 1

        sx = x - x0.to_f
        sy = y - y0.to_f

        n0 = dotGridGradient(x0, y0, x, y)
        n1 = dotGridGradient(x1, y0, x, y)
        ix0 = lerp(n0, n1, sx)

        n0 = dotGridGradient(x0, y1, x, y)
        n1 = dotGridGradient(x1, y1, x, y)
        ix1 = lerp(n0, n1, sx)
        return value = lerp(ix0, ix1, sy);
    end

    # 'Translated' from C++ to Ruby
    # All credits to DevDad: https://github.com/devdad/SimplexNoise
    #
    # Simplex noise is a method for constructing an n-dimensional noise function comparable to 
    # Perlin noise ("classic" noise) but with fewer directional artifacts and, in higher dimensions, 
    # a lower computational overhead. Ken Perlin designed the algorithm in 2001 to address the 
    # limitations of his classic noise function, especially in higher dimensions.
    def self.simplex(x, y = 0)
        perm = [151,160,137,91,90,15, 131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
                190,6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
                88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
                77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
                102,143,54,65,25,63,161,1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
                135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
                5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
                223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
                129,22,39,253,19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
                251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
                49,192,214,31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
                138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180, 151,
                160,137,91,90,15,131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,
                37,240,21,10,23,190,6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,
                11,32,57,177,33,88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,
                139,48,27,166,77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,
                46,245,40,244,102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
                135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
                5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
                223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
                129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
                251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
                49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
                138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180]
        f2 = 0.366025403
        g2 = 0.211324865

        s = (x + y) * f2
        xs = x + s
        ys = y + s
        i = xs.floor
        j = ys.floor

        t = (i + j) * g2
        x0 = i - t
        y0 = j - t
        x_0 = x - x0
        y_0 = y - y0

        if(x_0 > y_0)
            i1 = 1
            j1 = 0
        else
            i1 = 0
            j1 = 1
        end

        x1 = x_0 - i1 + g2
        y1 = y_0 - j1 + g2
        x2 = x_0 - 1.0 + 2.0 * g2
        y2 = y_0 - 1.0 + 2.0 * g2

        ii = i & 0xff
        jj = j & 0xff

        t0 = 0.5 - x_0 * x_0 - y_0 * y_0
        if(t0 < 0.0)
            n0 = 0.0
        else
            t0 *= t0
            n0 = t0 * t0 * grad(perm[ii + perm[jj]], x_0, y_0)
        end

        t1 = 0.5 - x1 * x1 - y1 * y1
        if(t1 < 0.0)
            n1 = 0.0
        else
            t1 *= t1
            n1 = t1 * t1 * grad(perm[ii + i1 + perm[jj + j1]], x1, y1)
        end

        t2 = 0.5 - x2 * x2 - y2 * y2
        if(t2 < 0.0)
            n2 = 0.0
        else
            t2 *= t2
            n2 = t2 * t2 * grad(perm[ii + 1 + perm[jj + 1]], x2, y2)
        end

        return 40.0 / 0.884343445 * (n0 + n1 + n2)
    end

    # If no argument is passed, randomly generates a greyscale RGB array.
    # Otherwise, returns a greyscale array with that argument normalized.
    def self.grayscale(val = nil)
        if(val)
            c = normalize(val, 0, 255).abs
        else
            c = rand()
        end
        return [c, c, c, 1.0]
    end

    # Computes the natural logarithm of `x`
    #
    # ...
    # No, don't ask. I'm just lazy.
    def self.ln(x)
        return Math.log(x, Math::E)
    end

    # Computes the numerical derivative of a function `f` in `a`
    # `f` MUST be a method, and it must be passed as an argument with the
    # :method_name syntax.
    # For example, if you wish to derivate the following method/function:
    #
    # def square(x)
    #   x ** 2
    # end
    #
    # Derivate it by doing:
    # `diff(:square, a)`, `a` being the point in x.
    def self.diff(f, a)
        lim = 1e-10
        return (method(f).call(a + lim) - method(f).call(a)) / lim
    end

    # Computes the definite integral of a function `f` from `a` to `b`
    # `f` MUST be a method, and it must be passed as an argument with the
    # :method_name syntax.
    # For example, if you wish to integrate the following method/function:
    #
    # def square(x)
    #   x ** 2
    # end
    #
    # Integrate it by doing:
    # `integral(:square, a, b)`, `a` and `b` being the limits of integration.
    def self.integral(f, a, b)
        n = 1e6
        delta_x = (b - a) / n
        result = 0
        for i in 0..n
            result += method(f).call((i * delta_x) + a) * delta_x
        end
        return result
    end

    private
    def self.randomGradient(ix, iy)
        random = 2920.0 * Math.sin(ix * 21942.0 + iy * 171324.0 + 8912.0) * Math.cos(ix * 23157.0 * iy * 217832.0 + 9758.0)
        return [Math.cos(random), Math.sin(random)]
    end

    def self.dotGridGradient(ix, iy, x, y)
        gradient = randomGradient(ix, iy)
        dx = x - ix.to_f
        dy = y - iy.to_f
        return (dx * gradient[0]) + (dy * gradient[1])
    end

    def self.grad(hash, x, y)
        h = hash & 7
        u = h < 4 ? x : y
        v = h < 4 ? y : x
        return ((h & 1) ? -u : u) + ((h & 2) ? -2.0 * v : 2.0 * v)
    end
end