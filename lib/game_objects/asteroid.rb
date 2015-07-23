require 'game_object'

class Asteroid < GameObject
  def initialize(scene)
    super(scene)

    @asteroid_image = Gosu::Image.new("media/PNG/Meteors/meteorGrey_big1.png", :tileable => true)
    @x_velocity = rand(-4...4)
    @y_velocity = rand(-4...4)
    @x_position = rand(0...@scene.width)
    @y_position = rand(0...@scene.height)
    @rotation_momentum = 5
    @rotation_angular = 0
  end

  def update
    @x_position = @x_position + @x_velocity
    @y_position = @y_position + @y_velocity
    @x_position=@x_position.modulo(@scene.width)
    @y_position=@y_position.modulo(@scene.height)
    @rotation_angular = (@rotation_angular + @rotation_momentum)
  end

  def draw
#    @asteroid_image.draw(@x_position, @y_position, 1)
    @asteroid_image.draw_rot(@x_position, @y_position, 1, @rotation_angular)
  end
end