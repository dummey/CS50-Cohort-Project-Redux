class Player
  def initialize(width, height)
    #scale ship
    @player = Gosu::Image.new("media/PNG/playerShip3_green.png")
  end

  def update

  end

  def draw
    @player.draw(69, 69, 1)
  end
end
