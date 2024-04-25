RSpec.describe Rails do
  expected_rails_version = ENV.fetch("RAILS_MAJOR_MINOR", nil)
  if expected_rails_version.nil?
    it "has loaded the default Rails Version" do
      # When not otherwise set, Rails should be 7.1
      expect(actual_rails_version).to match("7.1")
    end
  else
    it "has loaded the custom Rails Version" do
      actual_rails_version = "#{described_class::VERSION::MAJOR}.#{described_class::VERSION::MINOR}"
      expect(expected_rails_version).to eq(actual_rails_version)
    end
  end
end
