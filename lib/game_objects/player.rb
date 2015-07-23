require 'game_object'

class Player < GameObject
  def initialize(scene)
    super(scene)
    @body = CP::Body.new(10.0, 150.0)
    scene.space.add_body(@body)
    @player = Gosu::Image.new("media/PNG/playerShip3_green.png")
    @x_velocity = 0
    @y_velocity = 0
    @x_position = @scene.width/2
    @y_position = @scene.height/2
    @angle = 0
  end

  def rotate(degrees)
    @angle = @angle + 5 * degrees
  end

  def update
    # constant negative velocity
  end

  def draw
    # (x, y, z, angle, center_x, center_y, scale_x, scale_y)
    @player.draw_rot(@x_position, @y_position, 1, @angle)

  end
end
