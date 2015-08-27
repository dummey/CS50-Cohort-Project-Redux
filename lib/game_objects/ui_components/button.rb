require 'game_object'

class Button < GameObject
  def _defaults(params)
    {
      :x_pos => @scene.width / 2,
      :y_pos => @scene.height / 2,
      :z_index => 100,
      :angle => 0,
      :scale => 1,

      :text => "Text",
      :text_color => 0xFF_000000,
      :text_size => 36,

      # :button_image_path => "#{$MEDIA_ROOT}/custom/blue_button.png",
      :button_image_path => "#{$MEDIA_ROOT}/PNG/UI/buttonBlue.png",
    }.merge(params)
  end

  def initialize(scene, params = {})
    super(scene)
    _defaults(params).each {|k,v| instance_variable_set("@#{k}", v)}

    @button_text = Gosu::Font.new(@text_size, :name => $CONFIG[:font])
    @button_image = Gosu::Image.new(@button_image_path)
  end

  def intersect?(x, y)
    if (x < (@x_pos - @button_image.width / 2))
      return false
    elsif (x > (@x_pos + @button_image.width / 2))
      return false
    end

    if (y < (@y_pos - @button_image.height / 2))
      return false
    elsif (y > (@y_pos + @button_image.height / 2))
      return false
    end

    return true
  end

  def update

    self
  end

  def draw
    #button
    @button_image.draw_rot(*self._image_pos_centered)

    #button text
    @button_text.draw_rel(@text, *self._text_pos_centered(2, -2), @text_color)

    #shadow
    @button_text.draw_rel(@text, *self._text_pos_centered(2 + 2, -2 + 2), 0x0F_FFFFFF)

    self
  end
end