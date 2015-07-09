class Background
  def initialize(width, height)
    @background_image = Gosu::Image.new($MEDIA_ROOT + "/Backgrounds/purple.png", :tileable => true)

    @x_num = (width/@background_image.width).to_i
    @y_num = (height/@background_image.height).to_i

    @cycle = 0
  end

  def update
    @cycle -= 0.1
  end

  def draw
    for i in -1..@x_num
      for j in -1..@y_num
        @background_image.draw(i*@background_image.width + @cycle % @background_image.width, j*@background_image.height + @cycle % @background_image.height, 0)
      end
    end
  end
end
