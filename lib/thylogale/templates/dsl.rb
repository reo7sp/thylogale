module Thylogale
  def self.template(name, &block)
    template = Templates::Base.new(name)
    template.instance_eval(&block)
    SiteConfigs._loaded_templates << template
  end
end
