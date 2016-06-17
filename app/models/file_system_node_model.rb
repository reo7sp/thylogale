class FileSystemNodeModel
  include ActiveModel::Model
  include ActiveModel::Dirty

  attr_accessor :name, :location
  attr_reader :errors
  define_attribute_methods :name, :location
  alias_method :id, :path
  alias_method :id=, :path=

  def initialize(hash)
    super(hash)
    @errors = []
  end

  def name=(name)
    name_will_change!
    super(name)
  end

  def location=(location)
    location_will_change!
    super(location)
  end

  def path
    build_path(name, location)
  end

  def path=(path)
    parts = path.rpartition('/')
    self.location = parts[0]
    self.name = parts[2]
  end

  def abs_path
    build_abs_path(root_location, path)
  end

  def path_changed?
    name_changed? || location_changed?
  end

  def path_change
    if path_changed?
      [path_was, path]
    else
      nil
    end
  end

  def path_was
    build_path(name_was, location_was)
  end

  def path_restore
    name_restore
    location_restore
  end

  def abs_path_was
    build_abs_path(root_location, path_was)
  end

  def persisted?
    true
  end

  def save!
    if path_changed?
      FileUtils.mv(abs_path_was, abs_path)
    end
    changes_applied
  end

  def save
    save!
    true
  rescue => e
    @errors << e
    false
  end

  def destroy!
    FileUtils.rm_r(abs_path)
  end

  def destroy
    destroy!
    true
  rescue => e
    @errors << e
    false
  end

  protected
    def build_path(name, location)
      if location.blank?
        if name.blank?
          ''
        else
          "#{name}"
        end
      else
        if name.blank?
          "#{location}"
        else
          "#{location}/#{name}"
        end
      end
    end

  def build_abs_path(root, path)
    if path.empty?
      "#{root}"
    else
      "#{root}/#{path}"
    end
  end
end