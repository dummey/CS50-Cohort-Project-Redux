require 'game_object'

class Asteroid < GameObject
  def initialize(scene)
    super(scene)

    @asteroid_image = Gosu::Image.new("media/PNG/Meteors/meteorGrey_big1.png", :tileable => true)
    @x_velocity = rand(-100...100)
    @y_velocity = rand(-100...100)
    @x_position = rand(0...@scene.width)
    @y_position = rand(0...@scene.height)
    @rotation_momentum = rand(-10...10)
    @rotation_angular = rand(-10...10)
  end

  def update
    update_in_seconds = @scene.update_interval / 1000.0
    @x_position = @x_position + @x_velocity * update_in_seconds
    @y_position = @y_position + @y_velocity * update_in_seconds
    @x_position=@x_position.modulo(@scene.width)
    @y_position=@y_position.modulo(@scene.height)
    @rotation_angular = (@rotation_angular + @rotation_momentum * @scene.update_interval / 1000.0)
  end

  def draw
#    @asteroid_image.draw(@x_position, @y_position, 1)
    @asteroid_image.draw_rot(@x_position, @y_position, 1, @rotation_angular)
  end

  def die
  end
end