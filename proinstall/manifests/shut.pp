class proinstall::shut {
	file { "/etc/selinux/config":
		ensure	=>	'file',
		alias	=>	'config file',
	}	
	Exec { path	=>	['/bin','/usr/sbin','/usr/bin','/sbin'] }
	exec { "check and set selinux in file":
		cwd	=>	'/etc/selinux',
		unless	=>	"grep -P '^\s*SELINUX=disabled' config",
		command	=>	'sed "s/^\s*SELINUX=/#&/" config && echo "SELINUX=disabled" >> config',
		require	=>	File['config file'],
	}
	exec { "check and set selinux in cmd":
		unless	=>	'getenforce | egrep "Disabled|Permissive" ',
		command =>	'setenforce 0',
	}
	exec { "stop fw":
		command	=>	'service iptables stop;service ip6tables stop;chkconfig ip6tables off;chkconfig iptables off',
	}

	file { "/etc/sysconfig/clock":
		ensure	=>	'file',
		alias	=>	'timezone file',
	}
	file { "/usr/share/zoneinfo/Asia/Shanghai":
		ensure	=>	'file',
		alias	=>	'Shanghai temp'
	}

	exec { "change timezone":
		cwd	=>	'/etc/sysconfig',
		require	=>	File['timezone file','Shanghai temp'],
		command	=>	"perl -pi -e 's#\w+/\w+#Asia/Shanghai# if m/^ZONE/' clock;cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime",
	}
	
	cron { "ntp update":
		command	=>	'/usr/sbin/ntpdate 192.168.11.142 && /sbin/hwclock -w',
		user	=>	'root',
		hour	=>	23,
		minute	=>	30,
	}	
	
}
