require 'gosu'
require 'game_object'

class CreditsText < GameObject
  def _defaults(params)
    {
      :text => "programmers\n\ndummey\nemeraldvision\nmuseummile\njbtule\nLucySchroeder
        \nmusic\n\ndigital fallout, by eric matyas\n80's space game loop, by eric matyas",
      :text_image => nil,
      :font => $MEDIA_ROOT + "/ext/uipack-space/Fonts/kenvector_future_thin.ttf",
      :x_pos => @scene.width/2,
      :y_pos => @scene.height/2,
      :z_index => 10,
      :scale => 1,
      :angle => 0,
    }.merge(params)
  end

  def initialize(scene, params = {})
    super(scene)
    _defaults(params).each {|k,v| instance_variable_set("@#{k}", v)}

    @text_image = Gosu::Image.from_text(@text, 40, :font => @font, :align => :center, :width => @scene.width - 250)
  end

  def update

    self
  end

  def draw
    @angle = Gosu.angle(@x_pos, @y_pos, @scene.mouse_x, @scene.mouse_y)
    @text_image.draw_rot(@x_pos + 2, @y_pos + 2, @z_index, 0.5, 0.5, 0x40_000000)
    @text_image.draw_rot(@x_pos, @y_pos, @z_index, 0.5, 0.5)

    self
  end
end