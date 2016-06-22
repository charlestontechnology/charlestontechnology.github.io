require_relative "test_helper"

class FaqTest < ChsTech::Test
  # Ensure the people profile YAML documents can be coerced into a hash
  def test_faq_is_valid_yaml
    collection_files(:faq).each do |filename|
      assert_respond_to YAML.load_file(filename), :to_h, "#{filename} isn't valid faq data"
    end
  end
end
