class Player
  def initialize(width, height)
    #scale ship
    @player = Gosu::Image.new("media/PNG/playerShip3_green.png")
    @x_velocity = 0
    @y_velocity = 0
    @x_position = width/2
    @y_position = height/2
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