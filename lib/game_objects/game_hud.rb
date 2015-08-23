require 'game_objects/ui_components/score'

class GameHUD
  def initialize(scene)
    @scene = scene

    @lives_icon = Gosu::Image.new($MEDIA_ROOT + "/PNG/UI/playerLife3_green.png")
    # @score_font = Gosu::Font.new(25, :name => $MEDIA_ROOT + "/ext/uipack-space/Fonts/kenvector_future_thin.ttf")
    @score = Score.new(scene)
  end

  def _draw_lives
    @scene.lives.times do |i|
      @lives_icon.draw(10 + 40 * i, 10, 2)
    end
  end

  def update
    @score.score = @scene.score
    @score.update

    self
  end

  def draw
    self._draw_lives
    @score.draw

    self
  end
end
