class Page < FileSystemNodeModel
  attr_accessor :title
  define_attribute_methods :title
  validates :name, presence: true

  def title=(title)
    title_will_change!
    super(title)
  end

  def root_location
    ThylogaleConfig.pages_location
  end

  def load
    meta_path = "#{ThylogaleConfig.meta_location}/#{path}.json"
    if File.readable?(meta_path)
      json = File.read(meta_path).as_json
      self.title = json['title']
    end
  end

  def update!(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
    save!
  end

  def update(hash)
    update!(hash)
    true
  rescue => e
    @errors << e
    false
  end

  def save!
    super
    if title_changed?
      meta_path = "#{ThylogaleConfig.meta_location}/#{path}.json"
      json = {title: title}.as_json
      File.write(meta_path, json)
    end
  end

  def destroy!
    super
    FileUtils.rm("#{ThylogaleConfig.meta_location}/#{path}.json")
    FileUtils.rm_r("#{ThylogaleConfig.meta_location}/#{path}.json")
  end

  def self.create(hash)
    page = new(hash)
    FileUtils.touch(page.abs_path)
    page.save!
    page
  end

  def self.find(id)
    find_by(id: id)
  end

  def self.find_by(hash)
    page = new(hash)
    if File.exists?(page.abs_path)
      page.load unless (page.attributes.keys - hash.keys).empty?
      page
    else
      nil
    end
  end
end