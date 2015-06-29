include_recipe 'eclipse'

eclipse_dir = "#{node['ark']['prefix_home']}/eclipse"
pleiades_filename=File.basename node['pleiades']['url']

remote_file "#{Chef::Config[:file_cache_path]}/#{pleiades_filename}" do
  source node['pleiades']['url']
end

execute 'install_pleiades' do
        cwd Chef::Config[:file_cache_path]
        command <<-EOH
        unzip "#{Chef::Config[:file_cache_path]}/#{pleiades_filename}" -d ./
        cp -f -r features/jp.sourceforge.mergedoc.pleiades #{eclipse_dir}/features
        cp -f -r plugins/jp.sourceforge.mergedoc.pleiades #{eclipse_dir}/plugins
        EOH
        not_if { ::File.exists?("#{Chef::Config[:file_cache_path]}/plugins/jp.sourceforge.mergedoc.pleiades")}
end

template "#{eclipse_dir}/eclipse.ini" do
  owner 'root'
  group 'root'
  mode "0664"
  variables({
    :jar_path => "#{eclipse_dir}/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar"
  })
end

