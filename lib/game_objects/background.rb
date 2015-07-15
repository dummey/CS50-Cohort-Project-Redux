class Background
  ##
  # <b>Parameters</b>
  # * window (Gosu::Window) -- object that this background will be drawn in.
  # * params (Hash)
  #   * :velocity => [x,y]
  #   * :image => 
  def initialize(window, params = {})
    params[:velocity] ||= [0,0]
    params[:image] ||= nil

    @window = window

    @background_image = Gosu::Image.new(params[:image], :tileable => true)

    @x_num = (@window.width/@background_image.width).to_i
    @y_num = (@window.height/@background_image.height).to_i

    @x_vel, @y_vel = params[:velocity]

    @cycle = 0
  end

  def update
    @cycle -= 0.1
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
  end
end
