include_recipe 'eclipse'

eclipse_dir = "#{node['ark']['prefix_home']}/eclipse"
pleiades_dir = '/tmp/pleiades'
pleiades_zip = pleiades_dir + '/' + File.basename node['pleiades']['url']
darkjuno_zip = File.basename node['pleiades']['darkjuno']

directory pleiades_dir do
	action :create
	not_if { ::File.exists?(pleiades_dir) }
end

execute 'install_pleiades' do
	cwd pleiades_dir
	command <<-EOH
	wget #{node['pleiades']['url']}
	unzip #{pleiades_zip} -d ./
	cp -f -r features/jp.sourceforge.mergedoc.pleiades #{eclipse_dir}/features
	cp -f -r plugins/jp.sourceforge.mergedoc.pleiades #{eclipse_dir}/plugins
	echo -javaagent:#{eclipse_dir}/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar >> #{eclipse_dir}/eclipse.ini
	EOH
end

execute 'install dark juno' do
	cwd pleiades_dir
	command <<-EOH
	wget #{node['pleiades']['darkjuno']}
	unzip #{darkjuno_zip} -d ./
	cp -f -r plugins #{eclipse_dir}/
	EOH
end

