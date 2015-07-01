require 'gosu'

class MyWindow < Gosu::Window
  def initialize
    super(800, 600, false)
    self.caption = 'Damnit!'

    @background = Background.new(self.width, self.height)
  end

  def update

  end

  def draw
    @background.draw
  end
end

class Background
  def initialize(width, height)
    @background_image = Gosu::Image.new("media/Backgrounds/purple.png", :tileable => true)
  
    @x_num = (width/@background_image.width).to_i
    @y_num = (height/@background_image.height).to_i

    @count = 0
  end

  def draw 
    for i in -1..@x_num
      for j in -1..@y_num
        @background_image.draw(i*@background_image.width + @count % @background_image.width, j*@background_image.height + @count % @background_image.height, 0)
      end
    end

    @count -= 1
  end
end

class Player

end

class Astroids

end

window = MyWindow.new
window.show
