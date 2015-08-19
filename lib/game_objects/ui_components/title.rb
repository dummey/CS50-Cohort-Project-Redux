require 'game_object'

class Title < GameObject
  def _defaults(params)
    {
      :x_pos => @scene.width / 2,
      :y_pos => @scene.height * 1/3,
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
    @font.draw_rel(@text, @x_pos + 2, @y_pos + 2, @z_index, 0.5, 0.5, @scale, @scale, 0x40_000000)
    @font.draw_rel(@text, @x_pos, @y_pos, @z_index, 0.5, 0.5)

    self
  end
end