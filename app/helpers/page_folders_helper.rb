module PageFoldersHelper
  def entry_path(entry, type)
    case type
      when :folder
        page_folder_path entry
      when :page
        page_path entry
    end
  end

  def entry_icon(type)
    case type
      when :folder
        glyphicon 'folder-open'
      when :page
        glyphicon 'file'
    end
  end
end
