require 'game_object'

class Background < GameObject
  ##
  # <b>Parameters</b>
  # * scene (Gosu::Window) -- object that this background will be drawn in.
  # * params (Hash)
  #   * :velocity => [x,y]
  #   * :image =>
  #   * :music =>
  def initialize(scene, params = {})
    super(scene)
    
    params[:velocity] ||= [0,0]

    @background_image = Gosu::Image.new(params[:image], :tileable => true)

    if params[:music]
      @music = Gosu::Song.new(params[:music])
    end

    @x_num = (@scene.width / @background_image.width).to_i
    @y_num = (@scene.height / @background_image.height).to_i

    @x_vel, @y_vel = params[:velocity]

    @cycle = 0
  end

  def update
    @music.play(true) unless @music.playing?

    @cycle -= 0.1

    return self
  end

  def draw
    x_shift = @cycle * @x_vel
    y_shift = @cycle * @y_vel

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
