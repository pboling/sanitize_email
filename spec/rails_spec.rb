RSpec.describe Rails do
  expected_rails_version = ENV.fetch("RAILS_MAJOR_MINOR", nil)
  actual_rails_version = "#{described_class::VERSION::MAJOR}.#{described_class::VERSION::MINOR}"
  if expected_rails_version.nil?
    it "has Rails Version (default, 7.1) matching actual #{actual_rails_version}" do
      # When not otherwise set, Rails should be 7.1
      expect(actual_rails_version).to match("7.1")
    end
  else
    it "has Rails Version (custom from ENV, #{expected_rails_version}) matching actual #{actual_rails_version}" do
      expect(actual_rails_version).to eq(expected_rails_version)
    end
  end
end
