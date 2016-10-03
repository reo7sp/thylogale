module PageHistory
  class << self
    def commit(message)
      git = Git.open(PageFolder.root.abs_path)
      git.add(all: true)
      git.commit(message)
    end
  end
end