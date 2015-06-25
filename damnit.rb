require 'gosu'

class MyWindow < Gosu::Window
  def initialize
    super(800, 600, false)
    self.caption = 'Damnit!'

    @background_image = Gosu::Image.new("media/Backgrounds/purple.png", :tileable => true)
    @z = 0
  end

  def update

  end

  def draw
    x = (self.width/@background_image.width).to_i
    y = (self.height/@background_image.height).to_i
    for i in -1..x
      for j in -1..y
        @background_image.draw(i*@background_image.width + @z % @background_image.width, j*@background_image.height + @z % @background_image.height, 0)
      end
    end
    @z-=1
  end
end

window = MyWindow.new
window.show
