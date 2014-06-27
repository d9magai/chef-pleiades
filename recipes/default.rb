include_recipe 'eclipse'

eclipse_dir = "#{node['ark']['prefix_home']}/eclipse";
pleiades_dir = '/tmp/pleiades';
pleiades_zip = pleiades_dir + '/pleiades_1.4.0.zip';

directory pleiades_dir do
	action :create
	not_if { ::File.exists?(pleiades_dir) }
end

bash 'install_pleiades' do
	cwd pleiades_dir
	code <<-EOH
	wget http://jaist.dl.sourceforge.jp/mergedoc/58165/pleiades_1.4.0.zip
	unzip #{pleiades_zip} -d ./
	cp -f -r features/jp.sourceforge.mergedoc.pleiades #{eclipse_dir}/features
	cp -f -r plugins/jp.sourceforge.mergedoc.pleiades #{eclipse_dir}/plugins
	echo -javaagent:#{eclipse_dir}/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar >> #{eclipse_dir}/eclipse.ini
	EOH
end

bash 'install dark juno' do
	cwd pleiades_dir
	code <<-EOH
	wget https://s3-ap-northeast-1.amazonaws.com/gui.development.environment/Eclipse-Juno-Dark.zip
	unzip Eclipse-Juno-Dark.zip -d ./
	cp -f -r plugins #{eclipse_dir}/
	EOH
end

