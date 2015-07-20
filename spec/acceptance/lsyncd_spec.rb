require 'spec_helper_acceptance'

test_lua = <<-EOS
settings {
  logfile = '/var/log/lsyncd/test.log',
  statusFile = '/var/log/lsyncd/test.status',
}

sync {
  default.rsync,
  source = "/tmp/a",
  target = "/tmp/b",
}
EOS

describe 'lsyncd' do
  context 'local sync' do
    it 'provisions with no errors' do
      # Create test directories
      shell 'mkdir /tmp/a'
      shell 'mkdir /tmp/b'
      # Copy over the lsyncd configuration file
      create_remote_file hosts, '/tmp/test.lua', test_lua
      # Check for clean provisioning and idempotency
      pp = <<-EOS
        include ::lsyncd
        lsyncd::process { 'local_copy':
          content => file('/tmp/test.lua'),
        }
      EOS
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
    it 'synchronises folders' do
      # Create a file and wait for at least 15s (default)
      shell('touch /tmp/a/test')
      shell('sleep 20')
      # Check the file has been synchronised
      shell('ls /tmp/b/test', :acceptable_exit_codes => 0)
    end
  end
end
