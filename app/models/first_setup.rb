class FirstSetup < ApplicationRecord
  after_initialize :initialize_s3, if: "save_choice == 's3'"

  validate on: :create do
    errors.add(:only_one_instance, 'is allowed') if FirstSetup.count > 0
  end

  validates_presence_of :site_domain, :save_choice, :email_choice, if: :done

  validates_presence_of :save_local_dir, if: "save_choice == 'local'"
  validates_presence_of :save_s3_access_key, :save_s3_secret, :save_s3_region, if: "save_choice == 's3'"

  validates_presence_of :email_mailgun_api_key, :email_mailgun_domain, if: "email_choice == 'mailgun'"

  attr_accessor :import_choice
  attr_accessor :import_file

  def self.instance
    first_or_create!
  end

  private

  def initialize_s3
    Aws.config.update(region: save_s3_region, credentials: Aws::Credentials.new(save_s3_access_key, save_s3_secret))
  end
end
