require 'gosu'

class MyWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = 'Damnit!'

    @background_image = Gosu::Image.new("media/Backgrounds/purple.png", :tileable => true)
  end

  def update

  end

  def draw
    @background_image.draw(100, 100, 0)
  end
end

window = MyWindow.new
window.show