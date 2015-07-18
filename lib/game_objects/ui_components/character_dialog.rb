require 'gosu'
require 'game_object'


class CharacterDialog < GameObject
  attr_reader :duration 

  def _defaults(params)
    {
      :character_image => "",
      :duration => 0.0,
      :text => ["Lorem ipsum dolor sit amet, consectetur adipiscing elit.", 
        "Suspendisse tempus velit ex, sed egestas tellus posuere at.",
        "Sed iaculis ex ut felis vehicula, tristique suscipit erat sodales.",
        "Praesent a mattis velit. In ut maximus tortor. Sed sed viverra est.",
        "Donec ut felis non ipsum volutpat egestas. Suspendisse et condimentum ipsum.",
        "Sed a urna dictum ligula ullamcorper porta in et metus."].join(" "),
      :text_image => nil,
      :text_box_image => $MEDIA_ROOT + "/ext/uipack-space/PNG/glassPanel_corners.png",
      :font => $MEDIA_ROOT + "/ext/uipack-space/Fonts/kenvector_future_thin.ttf",
      :x_pos => @scene.width / 2,
      :y_pos => @scene.height - 100,
      :x_scale => 1,
      :y_scale => 1,
      :angle => 0,
    }.merge(params)
  end

  def initialize(scene, params = {})
    super(scene)
    _defaults(params).each {|k,v| instance_variable_set("@#{k}", v)}

    @text_box = Gosu::Image.new(@text_box_image)
    @text_image = Gosu::Image.from_text(@text, 20, :font => @font, :align => :center, :width => @scene.width - 250)
  end

  def show_for(duration = 10000)
    @duration = duration
  end

  def update
    return unless @duration > 0.0

    @duration -= @scene.update_interval
  end

  def draw
    return unless @duration > 0.0

    @text_box.draw_rot(@x_pos, @y_pos, 10, @angle, 0.5, 0.5, @x_scale, @y_scale, ((0x0F) << 24) + 0xFFFFFF)

    if @text_image
      @text_image.draw_rot(@x_pos, @y_pos, 11, @angle, 0.5, 0.5, @x_scale, @y_scale)
    end
  end
end