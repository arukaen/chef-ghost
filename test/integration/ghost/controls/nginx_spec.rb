control 'Ghost Blog Nginx Config' do
  impact 1.0
  title 'Ghost Nginx Config'
  desc 'Checks that Nginx has been configured correctly to reverse proxy a Ghost Blog.'

  describe package('nginx') do
    it { should be_installed }
  end

  describe service('nginx') do
    it { should be_enabled }
    it { should be_installed }
    it { should be_running }
  end

  describe file('/etc/nginx/sites-available/test.conf') do
    its('content') { should match 'myblog.com' }
    its('content') { should match 'test' }
    its('content') { should match '2378' }
  end

  describe port(80) do
    it { should be_listening }
  end
end
