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

      @people = Hash[people_files.map do |filename|
        person_name = File.basename(filename).match(/\A(.*).md\Z/)[1]
        begin
          [person_name, YAML.load_file(filename).to_h]
        rescue NoMethodError
          [person_name, {}]
        end
      end]
    end

    # The people files that have been modified in this branch
    #
    # Returns an Array of people files
    def people_files
      return @people_files if defined? @people_files
      diffable_files = `git diff -z --name-only --diff-filter=ACMRTUXB origin/master`.split("\0")

      @people_files = diffable_files.select do |filename|
        File.extname(filename) == ".md" && File.dirname(filename).match(/\A_people\Z/)
      end
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
