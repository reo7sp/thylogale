module Thylogale
  def template(name, &block)
    SiteConfigs.templates << Templates::Base.new(name).instance_eval(&block)
  end
end
