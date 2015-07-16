class GameObject
  attr_accessor :demolish

  def initialize(scene)
    @scene = scene

    @demolish = false
  end

  def demolish? 
    @demolish
  end
end