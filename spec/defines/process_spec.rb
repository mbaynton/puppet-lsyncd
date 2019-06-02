require 'spec_helper'

describe 'lsyncd::process' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:title) { 'test' }
      let(:params) { {'content' => 'test'} }
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end

  systemd = {
    :supported_os => [
      {
        'operatingsystem'        => 'Ubuntu',
        'operatingsystemrelease' => ['16.04'],
      }
    ],
  }
  on_supported_os(systemd).each do |os, os_facts|
    context "on #{os} (testing systemd)" do
      let(:title) { 'test' }
      let(:params) { {'content' => 'test'} }
      let(:facts) { os_facts.merge({'systemd' => true}) }

      it { is_expected.to compile }
      it { is_expected.to contain_systemd__unit_file('lsyncd-test.service') }
    end
  end
end
