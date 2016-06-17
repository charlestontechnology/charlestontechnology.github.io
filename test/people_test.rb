require_relative "test_helper"

class PeopleTest < ChsTech::Test
  # Ensure the people profile YAML documents can be coerced into a hash
  def test_profile_is_valid_yaml
    people_files.each do |filename|
      assert_respond_to YAML.load_file(filename), :to_h, "#{filename} isn't valid people data"
    end
  end

  # Ensure supplied GitHub usernames are real
  def test_github_profile_exists
    people.each do |name, info|
      github_username = info.fetch("github", false)
      if github_username
        assert_kind_of Sawyer::Resource, octokit.user(github_username), "#{github_username} is not a real GitHub account"
      end
    end
  end
end
