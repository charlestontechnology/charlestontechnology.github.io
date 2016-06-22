require "octokit"
require "yaml"

require "minitest/autorun"

module ChsTech
  class Test < MiniTest::Test
    # All the people that we need to check. These are just the people entries
    # that have changes on this branch.
    #
    # Returns a Hash of names and people data

    def people
      return @people if defined? @people

      @people = Hash[collection_files(:people).map do |filename|
        person_name = File.basename(filename).match(/\A(.*).md\Z/)[1]
        begin
          [person_name, YAML.load_file(filename).to_h]
        rescue NoMethodError
          [person_name, {}]
        end
      end]
    end

    def collection_files(collection_name)
      @collection_files = {} unless defined? @collection_files
      @collection_files[collection_name] ||= diffable_files.select do |file_name|
        File.extname(file_name) == ".md" && File.dirname(file_name).match("/\\A_#{collection_name}]\\Z/")
      end
    end

    def diffable_files
      `git diff -z --name-only --diff-filter=ACMRTUXB origin/master`.split("\0")
    end

    # Octokit client for use in tests
    #
    # Returns a Octokit::Client Object
    def octokit
      @octokit ||= if ENV.include?("GH_TOKEN") && ENV.include?("GH_LOGIN")
                     Octokit::Client.new(
                       :login        => ENV["GH_LOGIN"],
                       :access_token => ENV["GH_TOKEN"],
                     )
                   else
                     Octokit::Client.new
                   end
    end
  end
end
