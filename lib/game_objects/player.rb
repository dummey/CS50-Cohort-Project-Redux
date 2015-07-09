class Player
  def initialize(width, height)
    #scale ship
    @player = Gosu::Image.new("media/PNG/playerShip3_green.png")
    @x_velocity = 0
    @y_velocity = 0
    @x_position = width/2 - @player.width/2
    @y_position = height/2 - @player.height/2
  end

  def update

  end

  def draw
    @player.draw(@x_position, @y_position, 1)
  end
end
