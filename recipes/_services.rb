 service 'nginx' do
    supports :status => true, :restart => true, :reload => true
    action   :nothing
 end

 service 'ghost' do
    supports :status => true, :restart => true, :reload => true
    action   :nothing
 end
