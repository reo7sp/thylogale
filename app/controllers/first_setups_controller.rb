class FirstSetupsController < ApplicationController
  before_action :check_done
  before_action :check_env

  def setup
  end

  def init
    @first_setup.transaction do
      save_setup
      create_admin_user
      create_site_root_folder
      import_site
    end

    redirect_to page_folders_path
  end

  private

  def check_done
    redirect_to page_folders_path if @first_setup.done
  end

  def check_env
    if ENV['SITE_DOMAIN'].nil?
      @error = t(:no_env_site_domain)
      render :error
    end
  end

  def first_setup_params
    params.require(:first_setup).permit(
        :import_choice, :import_file,
        :save_choice, :save_s3_access_key, :save_s3_secret, :save_s3_region,
        :email_choice, :email_mailgun_api_key, :email_mailgun_domain
    )
  end

  def admin_user_setup_params
    params.require(:admin_user).permit(:email, :password, :password_confirmation)
  end

  def save_setup
    additional_params = {
        done:           true,
        site_domain:    ENV['SITE_DOMAIN'],
        save_local_dir: File.join(ENV['SITES_DEFAULT_LOCATION'] || '/var/lib/thylogale/sites', ENV['SITE_DOMAIN'])
    }
    @first_setup.update!(first_setup_params.merge(additional_params))
  end

  def create_admin_user
    User.create!(admin_user_setup_params.merge(id: 1, name: 'admin'))
  end

  def create_site_root_folder
    PageFolder.create!(id: 1, name: '/', title: t(:site), path: '/')
  end

  def import_site
    case @first_setup.import_choice
    when 'new'
      scaffold_site
    when 'upload'
      extract_site
    end
  end

  def scaffold_site
    site_scaffold_folder = File.expand_path('../../../site_scaffold', __FILE__)

    entries = Dir[File.join(site_scaffold_folder, '**', '*')]
    entries.reject! do |f|
      File.directory?(f)
    end
    entries.each do |f|
      canonical_path = f.sub(site_scaffold_folder, '')
      canonical_path.slice!(0) if canonical_path[0] == '/'
      FileContainer.new(canonical_path).write(File.binread(f))
    end
  end

  def extract_site
    Zip::File.open(first_setup_params[:import_file]) do |zip|
      zip.each do |f|
        FileContainer.new(f.name).write(f.get_input_stream.read)
      end
    end
  end
end
