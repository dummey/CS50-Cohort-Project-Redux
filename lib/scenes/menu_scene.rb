MENU_BACKGROUND
MENU_BG_MUSIC

class MenuScene
  def initialize(width, height)
    @window_dimensions = [width, height]
    @background = Gosu::Image.new(MENU_BACKGROUND, :tileable => true)
    @bg_music = Gosu::Song.new(MENU_BG_MUSIC)
  end

  def update
    @bg_music.play(true) unless @bg_music.playing?
  end

  def _draw_background 
    #draw the background centered on screen
    x, y = @window_dimensions
    x = x/2
    y = y/2

    x2 = @background.width/2
    y2 = @background.height/2

    @background.draw(x - x2, y - y2, 0) 
  end

  def draw
    self._draw_background

  end

end