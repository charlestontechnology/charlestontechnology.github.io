require_relative "test_helper"

class CompanyTest < ChsTech::Test
  # Ensure the people profile YAML documents can be coerced into a hash
  def test_profile_is_valid_yaml
    collection_files(:company).each do |filename|
      assert_respond_to YAML.load_file(filename), :to_h, "#{filename} isn't valid company data"
    end
  end
end
