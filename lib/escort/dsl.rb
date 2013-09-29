require 'delegate'

module DSL
  def build(*args, &block)
    base = self.new(*args)
    delegator_klass = self.const_get('DSLDelegator')
    delegator = delegator_klass.new(base)
    delegator.instance_eval(&block)
    base
  end

  def dsl(&block)
    delegator_klass = Class.new(SimpleDelegator, &block)
    self.const_set('DSLDelegator', delegator_klass)
  end
end
