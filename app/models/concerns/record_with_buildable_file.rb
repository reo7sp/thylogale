module RecordWithBuildableFile
  extend ActiveSupport::Concern

  def root_build_path
    PageFolder.root.abs_build_path
  end

  def build_path
    make_build_path(path)
  end

  def build_path_was
    make_build_path(path_was)
  end

  def abs_build_path
    File.join(root_build_path, build_path)
  end

  def abs_build_path_was
    File.join(root_build_path, build_path_was)
  end

  def built_data
    File.binread(abs_build_path) rescue nil
  end

  private

  def make_build_path(path)
    ext = File.extname(path)
    if ext.in? BUILDABLE_FILE_EXTENSIONS
      make_build_path(path[0...-ext.length])
    else
      path
    end
  end

  BUILDABLE_FILE_EXTENSIONS = %w{.slim .erb .rhtml .erubis .less .builder .liquid .markdown .mkd .md .textile .rdoc .radius .mab .nokogiri .coffee .wiki .creole .mediawiki .mw .yajl .styl}
end