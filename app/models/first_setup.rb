class FirstSetup < ActiveRecord::Base
  before_create :confirm_singularity

  after_initialize :initialize_s3, if: "save_choice == 's3'"

  validates_presence_of :done, on: :update

  validates_presence_of :site_domain, :import_choice, :save_choice, :email_choice, if: :done

  validates_presence_of :save_local_dir, if: "save_choice == 'local'"
  validates_presence_of :save_s3_access_key, :save_s3_secret, :save_s3_region, if: "save_choice == 's3'"

  validates_presence_of :email_mailgun_api_key, :email_mailgun_domain, if: "email_choice == 'mailgun'"

  def self.instance
    if any?
      first
    else
      create!
    end
  end

  private

  def confirm_singularity
    raise 'Only one first setup is allowed' if FirstSetup.any?
  end

  def initialize_s3
    Aws.config.update({
      region: save_s3_region,
      credentials: Aws::Credentials.new(save_s3_access_key, save_s3_secret)
    })
  end
end
