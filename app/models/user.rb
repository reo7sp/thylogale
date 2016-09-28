class User < ApplicationRecord
  has_secure_password

  validates_presence_of :name, :email, :password_digest
  validates_uniqueness_of :email
  validates_format_of :email, with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  def is_admin?
    id == 1
  end

  def self.admin
    first
  end
end
