require 'gosu'

class MyWindow < Gosu::Window
  def initialize
   super(640, 480, false)
   self.caption = 'Damnit!'
  end
end

window = MyWindow.new
window.show