require 'game_object'

class Title < GameObject
  def _defaults(params)
    {
      :x_pos => 10,
      :y_pos => 50,
      :z_index => 10,
      :scale => 1,
      :text => 'PLACEHOLDER',
    }.merge(params)
  end

  def initialize(scene, params = {})
    super(scene)
    _defaults(params).each {|k,v| instance_variable_set("@#{k}", v)}

    @font = Gosu::Font.new(128, :name => $MEDIA_ROOT + "/ext/uipack-space/Fonts/kenvector_future_thin.ttf")
  end

  def update

    self
  end

  def draw
    @font.draw_rel(@text, @scene.width / 2 + 2, @scene.height * 1/3 + 2, 10, 0.5, 0.5, @scale, @scale, 0x40_000000)
    @font.draw_rel(@text, @scene.width / 2, @scene.height * 1/3, 10, 0.5, 0.5)

    self
  end
end