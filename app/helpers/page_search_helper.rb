module PageSearchHelper
  include PageFoldersHelper

  def get_type_of_result(result)
    case result
    when PageFolder
      :folder
    when Page
      :page
    end
  end
end
