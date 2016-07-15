class Thylogale::Templates::Handlers::Base
  def name
    self.class.to_s.demodulize.underscore
  end

  protected

  def register(as: name)
    Handlers.register_handler(as, self)
  end
end
