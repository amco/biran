require 'spec_helper'
require 'biran'

describe Biran do
  subject { described_class }

  it { expect(subject).to be_kind_of Module }
  it { expect(subject).to respond_to :configure }

  it 'app_env is configurable' do
    subject.configure do |config|
      config.app_env = 'test'
    end
    expect(described_class.config.app_env).to eq 'test'
  end

  it 'root_path is configurable' do
    subject.configure do |config|
      config.root_path = 'path/to/root/'
    end
    expect(described_class.config.root_path).to eq 'path/to/root/'
  end
end
