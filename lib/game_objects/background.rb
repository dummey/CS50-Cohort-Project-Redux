require 'game_object'
require 'gosu'

class Background < GameObject
  def _defaults(params)
    {
      :x_velocity => $CONFIG[:game_background_drift][:x],
      :y_velocity => $CONFIG[:game_background_drift][:y],
    }.merge(params)
  end

  ##
  # <b>Parameters</b>
  # * scene (Gosu::Window) -- object that this background will be drawn in.
  # * params (Hash)
  #   * :velocity => [x,y]
  #   * :image =>
  #   * :music =>
  def initialize(scene, params = {})
    super(scene)
    _defaults(params).each {|k,v| instance_variable_set("@#{k}", v)}


    @background_image = Gosu::Image.new(@image, :tileable => true)

    if @music
      @music = Gosu::Song.new(@music)
      @music.volume = 0.25
    end

    @x_num = (@scene.width / @background_image.width).to_i
    @y_num = (@scene.height / @background_image.height).to_i

    @cycle = 0
  end

  def update
    @music.play(true) unless @music.playing?

    @cycle -= @scene.update_interval

    return self
  end

  def draw
    x_shift = @cycle * @x_velocity / 100
    y_shift = @cycle * @y_velocity / 100

    for i in -1..@x_num
      for j in -1..@y_num
        @background_image.draw(
          i * @background_image.width + x_shift % @background_image.width,
          j * @background_image.height + y_shift % @background_image.height,
          0
        )
      end
    end

    return self
  end
end
