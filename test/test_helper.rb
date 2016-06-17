require "octokit"
require "yaml"

require "minitest/autorun"

module ChsTech
  class Test < MiniTest::Test
    # All the people that we need to check. These are just the people entries
    # that have changes on this branch.
    #
    # Returns a Hash of people data
    def people
      return @people if defined? @people

      @people = {}
      diffable_files = `git diff -z --name-only --diff-filter=ACMRTUXB origin/master`.split("\0")

      diffable_files.select do |filename|
        if File.extname(filename) == ".md" && File.dirname(filename).match(/\A_people\Z/)
          person_name = File.basename(filename).match(/\A(.*).md\Z/)[1]
          begin
            @people[person_name] = YAML.load_file(filename).to_h
          rescue NoMethodError
            @people[person_name] = {}
          end
        end
      end

      @people
    end

    # Octokit client for use in tests
    #
    # Returns a Octokit::Client Object
    def octokit
      @octokit ||= Octokit::Client.new
    end
  end
end
