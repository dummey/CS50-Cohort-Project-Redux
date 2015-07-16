require 'game_object'

class Asteroid < GameObject
  def initialize(scene)
    super(scene)

    @asteroid_image = Gosu::Image.new("media/PNG/Meteors/meteorGrey_big1.png", :tileable => true)
    @x_velocity = rand(-4...4)
    @y_velocity = rand(-4...4)
    @x_position = rand(0...@scene.width)
    @y_position = rand(0...@scene.height)
  end

  def update
    @x_position = @x_position + @x_velocity
    @y_position = @y_position + @y_velocity
    @x_position=@x_position.modulo(@scene.width)
    @y_position=@y_position.modulo(@scene.height)
  end

  def draw
    @asteroid_image.draw(@x_position, @y_position, 1)
  end
end