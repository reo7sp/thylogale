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
    create_template
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
        done: true,
        site_domain: ENV['SITE_DOMAIN'],
        save_local_dir: File.join(Locations.sites_default, ENV['SITE_DOMAIN'])
    }
    @first_setup.update!(first_setup_params.merge(additional_params))
  end

  def create_admin_user
    User.create!(admin_user_setup_params.merge(id: 1, name: 'admin'))
  end

  def create_template
    Template.create!(id: 1, name: 'markdown', )
  end

  def create_site_container
    PageFolder.create!(id: 1, name: '/', title: t(:site), path: '/', template: Template.first)
  end

  def import_site
    case @first_setup.import_choice
      when 'new'
        # TODO: create welcome page

      when 'upload'
        Zip::File.open(first_setup_params[:import_file]) do |zip|
          # TODO: import files
        end
    end
  end
end
