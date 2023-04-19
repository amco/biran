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

    it "will give safe_load correct arguments" do
      expect(YAML).to receive(:safe_load).with(data_content, aliases: true).and_return(hash_content)
      subject.files_to_generate
    end
  end

  describe "extra_config_file_contents" do
    it "will load extra config file contents with suffix" do
      allow_any_instance_of(described_class).to receive(:extra_config_suffix).and_return("test")
      expect(subject.config[:my_fifth_value]).to eq(55)
      expect(subject.config[:nested_values][:my_sixth_value]).to eq(66)
    end

    it "will load original file contents without suffix" do
      expect(subject.config[:my_fifth_value]).to eq(5)
      expect(subject.config[:nested_values][:my_sixth_value]).to eq(6)
    end
  end
end
