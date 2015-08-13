module Defaultable
  def _defaults()
    abort("_defaults needs to be defined for defalutable to work.")
  end

  def setup_defaults(params)
    _defaults.merge(params).each {|k,v| self.instance_variable_set("@#{k}", v)}
  end
end