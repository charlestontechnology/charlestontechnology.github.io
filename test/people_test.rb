require_relative "test_helper"

class PeopleTest < ChsTech::Test
  def test_github_profile_exists
    people.each do |name, info|
      github_username = info.fetch("github", false)
      if github_username
        assert_kind_of Sawyer::Resource, octokit.user(github_username)
      end
    end
  end
end
