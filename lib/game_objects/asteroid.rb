


class Asteroid
  def initialize(width, height)
    @asteroid_image = Gosu::Image.new("media/PNG/Meteors/meteorGrey_big1.png", :tileable => true)
    @x_velocity = rand(0...4)
    @y_velocity = rand(0...4)
    @x_position = 100
    @y_position = 100
  end