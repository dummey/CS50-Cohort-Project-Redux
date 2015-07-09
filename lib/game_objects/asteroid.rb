class Asteroid
  def initialize(width, height)
    @asteroid_image = Gosu::Image.new("media/PNG/Meteors/meteorGrey_big1.png", :tileable => true)
    @x_velocity = rand(0...4)
    @y_velocity = rand(0...4)
    @x_position = 100
    @y_position = 100
  end

  def update
@x_position = @x_position + @x_velocity
@y_position = @y_position + @y_velocity
  end

  def draw
    @asteroid_image.draw(@x_position, @y_position, 1)
  end
end