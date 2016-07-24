module Random
  RAND_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
      'abcdefghijklmnopqrstuvwxyz' +
      '0123456789'

  def self.string(len = 10)
    rand_max = RAND_CHARS.size
    ret      = ''
    len.times { ret << RAND_CHARS[rand(rand_max)] }
    ret
  end
end