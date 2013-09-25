define proinstall::yumconf ($name,$yumserver,$yumserverport,$yumpath,$comment){
	$yum_name	=	$name
	$yum_server_ip	=	$yumserver
	$yum_server_port	=	$yumserverport
	$yum_path	=	$yumpath
	$yum_comment	=	$comment
	file {"/etc/yum.repos.d/${yum_name}.repo":
		ensure	=>	'present',
		content	=>	template('proinstall/localos.repo.erb'),
	}		



}
