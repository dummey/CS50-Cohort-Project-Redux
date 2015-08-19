require 'gosu'
require 'game_object'

class Subtitle < GameObject
  def _defaults(params)
    {
      :spaceship_image => nil,
      :spaceship_image_path => $MEDIA_ROOT + "/PNG/playerShip3_green.png", 
      :text => "Use your arrow keys to move your\n\n\nand the space bar to shoot lasers!",
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

    #@font = Gosu::Font.new(35, :name => $MEDIA_ROOT + "/ext/uipack-space/Fonts/kenvector_future_thin.ttf")

    @text_image = Gosu::Image.from_text(@text, 40, :font => @font, :align => :center, :width => @scene.width - 250)
    @spaceship_image = Gosu::Image.new(@spaceship_image_path)
  end

  def update

    self
  end

  def draw
    @angle = Gosu.angle(@x_pos, @y_pos, @scene.mouse_x, @scene.mouse_y)
    @text_image.draw_rot(@x_pos + 2, @y_pos + 2, @z_index, 0.5, 0.5, 0x40_000000)
    @text_image.draw_rot(@x_pos, @y_pos, @z_index, 0.5, 0.5)

    @spaceship_image.draw_rot(@x_pos, @y_pos, @z_index, @angle)

    self
  end
end