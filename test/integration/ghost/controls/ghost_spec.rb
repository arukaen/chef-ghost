control 'Ghost Blog' do
  impact 1.0
  title 'Ghost Blog Tests'
  desc 'Checks that the Ghost Blog has been installed and configured correctly.'

  describe file('/var/www/html/ghost_1') do
    its('type') { should eq :directory }
    it { should be_directory }
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
  end

  describe file('/etc/init.d/ghost_test') do
    its('content') { should match '/var/www/html/ghost_1' }
    its('content') { should match 'ghost_test' }
  end

  describe file('/var/www/html/ghost_1/config.js') do
    its('content') { should match 'http://myblog.com' }
    its('content') { should match '2378' }
  end

  describe service('ghost_test') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe port(2378) do
    it { should be_listening }
  end
end
