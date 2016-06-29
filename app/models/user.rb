class User < ActiveRecord::Base
  has_secure_password

  validates_presence_of :name, :email, :password_digest
  validates_uniqueness_of :email
  validates_format_of :email, with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  def self.admin
    first
  end
end