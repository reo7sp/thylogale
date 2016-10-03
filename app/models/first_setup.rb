class FirstSetup < ApplicationRecord
  validate on: :create do
    errors.add(:only_one_instance, 'is allowed') if FirstSetup.count > 0
  end

  validates_presence_of :site_domain, :email_choice, if: :done
  validates_presence_of :email_mailgun_api_key, :email_mailgun_domain, if: "email_choice == 'mailgun'"

  attr_accessor :import_choice, :import_file

  def self.instance
    first_or_create!
  end
end
