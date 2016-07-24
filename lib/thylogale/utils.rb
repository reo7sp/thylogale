module Thylogale
  def self.random_string(len = 10)
    rand_max = RAND_CHARS.size
    result   = ''
    len.times { result << RAND_CHARS[rand(rand_max)] }
    result
  end

  private

  RAND_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
end