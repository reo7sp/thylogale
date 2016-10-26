module PageHistory
  class << self
    def commit(message)
      git = Git.open(FirstSetup.instance.save_local_dir)
      git.add(all: true)
      git.commit(message)
    end
  end
end