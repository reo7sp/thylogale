require_relative '../../lib/locations'

class FirstSetupsController < ApplicationController
  before_action :check_done
  before_action :check_env

  # GET /setup
  def setup
  end

  # POST /setup
  def init
    save_setup
    create_admin_user
    create_site_container
    import_site

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
    params.require(:first_setup).permit(:import_choice, :save_choice, :import_file, :save_s3_access_key, :save_s3_secret, :save_s3_region, :email_choice, :email_mailgun_api_key, :email_mailgun_domain)
  end

  def admin_user_setup_params
    params.require(:admin_user).permit(:email, :password, :password_confirmation)
  end

  def save_setup
    update_params = first_setup_params.to_h
    update_params[:done] = true
    update_params[:site_domain] = ENV['SITE_DOMAIN']
    update_params[:save_local_dir] = File.join(Locations.sites_default, ENV['SITE_DOMAIN'])
    update_params.delete(:import_file)
    @first_setup.update!(update_params)
  end

  def create_admin_user
    User.create!(admin_user_setup_params.to_h.merge(id: 1, name: 'admin'))
  end

  def create_site_container
    case @first_setup.save_choice
      when 'local'
        PageFolder.create!(id: 1, name: '/', title: t(:site), path: '/', container: 'local')

      when 's3'
        PageFolder.create!(id: 1, name: '/', title: t(:site), path: '/', container: 's3')
    end
  end

  def import_site
    case @first_setup.import_choice
      when 'new'
        # TODO: create welcome page

      when 'upload'
        zip_file = Tempfile.new('first_setup_site')
        begin
          zip_file.write(first_setup_params[:import_file])
          zip_file.close
          Zip::File.open(zip_file.path) do |zip|
            # TODO: import files
          end
        ensure
          zip_file.close!
        end
    end
  end
end
