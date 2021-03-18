require 'spec_helper'
require 'biran'

describe Biran::Configurinator do
  subject { described_class.new }

  it 'test' do
    expect(subject.files_to_generate).to eql({my_config: {extension: ".yml"}})
  end
end
