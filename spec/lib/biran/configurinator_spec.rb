require "spec_helper"
require "biran"

describe Biran::Configurinator do
  subject { described_class.new }

  it "test" do
    expect(subject.files_to_generate).to eql({my_config: {extension: ".yml"}})
  end

  describe "psycho version" do
    let(:data_content) { ERB.new(File.read("config/app_config.yml")).result }

    context "when psych version is < 4.0" do
      before(:example) do
        stub_const("Psych::VERSION", "3.2")
      end

      it "calls right method" do
        expect(YAML).to receive(:safe_load).with(data_content, [], [], true).and_call_original
        subject.files_to_generate
      end
    end

    context "when psych version is <> 4.0" do
      before(:example) do
        stub_const("Psych::VERSION", "4.0")
      end

      it "calls right method" do
        expect(YAML).to receive(:safe_load).with(data_content, aliases: true).and_call_original
        subject.files_to_generate
      end
    end
  end
end
