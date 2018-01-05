require 'spec_helper'
require 'biran'

describe Biran do
  subject { described_class }

  it { expect(subject).to be_kind_of Module }
  it { expect(subject).to respond_to :configure }

  context 'configure' do
    it 'app_env is configurable' do
      subject.configure { |config| config.app_env = 'test' }
      expect(described_class.config.app_env).to eq 'test'
    end

    it 'base_path is configurable' do
      subject.configure { |config| config.base_path = 'path/to/root/' }
      expect(described_class.config.base_path).to eq 'path/to/root/'
    end
  end

  it 'extension for config tasks contain period' do
    skip
  end
end
