source 'https://supermarket.chef.io'

metadata

group :integration do
  cookbook 'apt'
  cookbook 'yum'
end

cookbook 'nodejs', '~> 3.0.0'
cookbook 'test', path: 'test/cookbooks/test'
