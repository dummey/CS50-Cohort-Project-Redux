require 'scene'
require 'scene/game_scene'
require 'game_objects/background'

class MenuScene < Scene
  def initialize(window)
    super(window)

    @background = Background.new(MENU_BACKGROUND, :tileable => true)
    @bg_music = Gosu::Song.new(MENU_BG_MUSIC)
  end

  def update
    @bg_music.play(true) unless @bg_music.playing?

    if Gosu::KbSpace
      @window.scenes.push(GameScene.new(@window))
    end
  end

  def draw
    self._draw_background

  end

end