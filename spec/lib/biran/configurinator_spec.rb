require "spec_helper"
require "biran"

describe Biran::Configurinator do
  subject { described_class.new }

  describe "files_to_generate" do
    it "will generate my_config.yml" do
      expect(subject.files_to_generate).to eql({my_config: {extension: ".yml"}})
    end
  end

  describe "process_config_file" do
    let(:data_content) { ERB.new(File.read("config/app_config.yml")).result }
    let(:hash_content) { { "development" => {}, "test" => {} } }

    it "will handle aliases in yaml" do
      expect(subject.config[:my_first_value]).to eq(11)
      expect(subject.config[:my_second_value]).to eq(2)
    end

    it "will handle nested aliases in yaml" do
      expect(subject.config[:nested_values][:my_third_value]).to eq(13)
      expect(subject.config[:nested_values][:my_fourth_value]).to eq(4)
    end

    context "when psych version is < 4.0" do
      before(:example) do
        stub_const("Psych::VERSION", "3.2")
      end

      it "safe_laod should get correct arguments" do
        expect(YAML).to receive(:safe_load).with(data_content, [], [], true).and_return(hash_content)
        subject.files_to_generate
      end
    end

    context "when psych version is >= 4.0" do
      before(:example) do
        stub_const("Psych::VERSION", "4.0")
      end

      it "safe_laod should get correct arguments" do
        expect(YAML).to receive(:safe_load).with(data_content, aliases: true).and_return(hash_content)
        subject.files_to_generate
      end
    end
  end
end
