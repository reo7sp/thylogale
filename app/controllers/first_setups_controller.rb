class FirstSetupsController < ApplicationController
  # GET /setup
  def setup
  end

  # POST /setup
  def init
    update_params = first_setup_params.to_h
    update_params[:done] = true
    update_params[:site_domain] = ENV['SITE_DOMAIN']
    update_params[:save_local_dir] = File.join(Locations.sites_default, ENV['SITE_DOMAIN'])
    update_params.delete(:import_file)
    @first_setup.update(update_params)

    create_admin_user
    create_site_container
    import_site

    redirect_to page_folders_path
  end

  private

  def first_setup_params
    params.require(:first_setup).permit(:import_choice, :save_choice, :import_file, :save_s3_access_key, :save_s3_secret, :save_s3_region, :admin_user)
  end

  def create_admin_user
    Users.create(id: 1, name: 'admin', email: first_setup_params[:admin_email], password: first_setup_params[:admin_password])
  end

  def create_site_container
    case first_setup_params[:save_choice]
      when 'local'
        PageFolder.create(id: 1, name: '/', title: t(:site), path: '/', container: 'local')

      when 's3'
        PageFolder.create(id: 1, name: '/', title: t(:site), path: '/', container: 's3')
    end
  end

  def import_site
    case first_setup_params[:import_choice]
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
