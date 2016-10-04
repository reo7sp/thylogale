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
    add_all_erb_to_page_database
  end

  def add_all_erb_to_page_database
    root_path = File.join(@first_setup.save_local_dir, 'source')
    glob = File.join(root_path, '**', '*.html.md.erb')
    entries = Dir.glob(glob)
    entries.each do |abs_path|
      canonical_path = abs_path[root_path.length+1..-1]

      name = File.basename(canonical_path, '.html.md.erb')

      dirname = File.dirname(canonical_path)
      root_folder = (dirname == '.') ? PageFolder.root : PageFolder.where(path: dirname)
      unless root_folder
        path_parts = dirname.split('/')
        memo = path_parts.each_with_object({path: '', last_dir: PageFolder.root}) do |path_part, memo|
          memo[:path] << '/' unless memo.path.empty?
          memo[:path] << path_part
          memo[:last_dir] = PageFolder.find_or_create_by!(path: memo.path, root_folder: memo[:last_dir])
        end
        root_folder = memo[:last_dir]
      end

      Page.create!(name: name, root_folder: root_folder, path: canonical_path)
    end
  end

  def scaffold_site
    site_scaffold_folder = File.expand_path('../../../site_scaffold', __FILE__)
    FileUtils.mkdir_p(@first_setup.save_local_dir)
    FileUtils.cp_r("#{site_scaffold_folder}/.", @first_setup.save_local_dir)
  end

  def extract_site
    Zip::File.open(first_setup_params[:import_file]) do |zip|
      zip.each do |f|
        f.extract(File.join(@first_setup.save_local_dir, f.name))
      end
    end
  end
end
