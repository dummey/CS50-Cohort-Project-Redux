require 'gosu'

require 'scene'
require 'scenes/game_scene'
require 'game_objects/background'

class MenuScene < Scene
  def initialize(window)
    super(window)

    p @window

    @background = Background.new(self, {
                                   :image => $MEDIA_ROOT + "/Backgrounds/black.png",
                                   :music => $MEDIA_ROOT + "/Music/Digital-Fallout_v001.ogg"
    })

    @updatable.push(@background)
    @drawable.push(@background)

    @text = Gosu::Font.new(25)
  end

  def update
    super

    if (@window.button_down?(Gosu::KbSpace))
      @window.scenes.push(GameScene.new(@window))
    end
  end

  def draw
    super

  end

end