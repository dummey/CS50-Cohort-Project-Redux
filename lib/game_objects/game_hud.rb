class GameHUD
  def initialize(scene)
    @scene = scene

    @lives_icon = Gosu::Image.new($MEDIA_ROOT + "/PNG/UI/playerLife3_green.png")
    @score_font = Gosu::Font.new(25, :name => $MEDIA_ROOT + "/ext/uipack-space/Fonts/kenvector_future_thin.ttf")

  end

  def _draw_lives
    @scene.lives.times do |i|
      @lives_icon.draw(10 + 40 * i, 10, 1)
    end
  end

  def _draw_score
    @scene.score
    @score_font.draw("Score: #{@scene.score}", 10,40,1)
  end

  def draw
    self._draw_lives
    self._draw_score
  end
end
