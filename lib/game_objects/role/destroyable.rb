module Destroyable
  def destroy
    p 'being destroyed'
    @destroyed = true
  end

  def destroyed?
    @destroyed
  end
end