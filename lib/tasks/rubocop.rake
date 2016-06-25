namespace :rubocop do
  # Fetch new files from repo to protect with Rubocop
  class FilesList
    PROTECTED_FILES = %w(
      app/cells/
      spec/cells/
      lib/tasks/rubocop.rake
    ).freeze

    PROTECT_SINCE_COMMIT = 'dbd22e3de1d8c796940c43864e0689f4ab10123b'.freeze

    def files
      PROTECTED_FILES + new_protected_files
    end

    private

    def file_protected?(path)
      return false if path =~ /^vendor/
      return false if path =~ %r{^db/migrate}
      return true if path =~ /\.(rb|rake)$/

      false
    end

    def new_protected_files
      new_files.select { |f| file_protected?(f) }
    end

    def new_files
      cmd = "git diff #{PROTECT_SINCE_COMMIT} --summary"
      cmd << '| grep create | awk \'{print $4}\''

      `#{cmd}`.split("\n")
    end
  end

  desc 'run rubocop'
  task :run do
    files_list = FilesList.new

    exec "rubocop #{files_list.files.join(' ')}"
  end
end
