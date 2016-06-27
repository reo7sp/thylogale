class FirstSetup < ActiveRecord::Base
  before_create :confirm_singularity
  after_initialize :initialize_s3, if: :using_s3?

  def self.instance
    first
  end

  private

  def confirm_singularity
    raise 'Only one first setup is allowed' if FirstSetup.count > 0
  end

  def initialize_s3
    Aws.config.update({
      region: save_s3_region,
      credentials: Aws::Credentials.new(save_s3_access_key, save_s3_secret)
    })
  end

  def using_s3?
    save_choice == 's3'
  end
end
