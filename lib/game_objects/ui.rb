class UI
  def initialize
    @lives = 3
    @lives_icon = Gosu::Image.new($MEDIA_ROOT + "/PNG/UI/playerLife1_blue.png")
    @score = 0
    @font = Gosu::Font.new(25)

  end

  def _draw_lives
    @lives.times do |i|
      @lives_icon.draw(10 + 40 * i, 10, 1)
    end
  end

  def _draw_score

  end

  def draw
    # @font.draw("Lives: #{@lives}", 10,10,1)
    self._draw_lives
    @font.draw("Score: #{@score}", 10,40,1)
  end
end
