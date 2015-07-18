require 'gosu'
require 'game_object'


class CharacterDialog < GameObject
  attr_reader :duration 

  def _defaults(params)
    {
      :character_image => nil,
      :character_image_path => $MEDIA_ROOT + "/custom/kinda_sorta_crystal.png",
      :character_bg_image => nil,
      :character_bg_image_path => $MEDIA_ROOT + "/custom/portrait_bg.png",
      :duration => 0.0,
      :text => ["Blast those astroids!"].join(" "),
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
    @text_image = Gosu::Image.from_text(@text, 32, :font => @font, :align => :center, :width => @scene.width - 250)
    @character_image = Gosu::Image.new(@character_image_path)
    @character_bg_image = Gosu::Image.new(@character_bg_image_path)
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

    # @text_box.draw_rot(@x_pos, @y_pos, 10, @angle, 0.5, 0.5, @x_scale, @y_scale, ((0x0F) << 24) + 0xFFFFFF)

    if @text_image
      @text_image.draw_rot(@x_pos, @y_pos, 11, @angle, 0.5, 0.5, @x_scale, @y_scale, ((0x8F) << 24) + 0xFFFFFF)
      @text_image.draw_rot(@x_pos+2, @y_pos+2, 10, @angle, 0.5, 0.5, @x_scale, @y_scale, ((0x0F) << 24) + 0xAAAAAA)
    end

    @character_bg_image.draw_rot(@character_image.width, @y_pos, 11, @angle, 0.5, 0.5, @x_scale, @y_scale, ((0x0F) << 24) + 0xFFFFFF)
    @character_image.draw_rot(@character_image.width, @y_pos, 12, @angle, 0.5, 0.5, @x_scale, @y_scale, ((0x20) << 24) + 0xFFFFFF)
  end
end