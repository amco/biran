require 'spec_helper'
require 'biran/config'

describe Biran::Config do
  subject { described_class.instance }

  it { is_expected.to respond_to :app_env }
  it { is_expected.to respond_to :base_dir }
  it { is_expected.to respond_to :config_filename }
  it { is_expected.to respond_to :local_config_filename }
  it { is_expected.to respond_to :db_config_filename }
  it { is_expected.to respond_to :secrets_filename }
  it { is_expected.to respond_to :use_capistrano }
  it { is_expected.to respond_to :files_to_generate }
  it { is_expected.to respond_to :db_config }
  it { is_expected.to respond_to :secrets }
  it { is_expected.to respond_to :app_setup_blocks }
  it { is_expected.to respond_to :bindings }
  it { is_expected.to respond_to :base_path }
  it { is_expected.to respond_to :shared_dir }
end
