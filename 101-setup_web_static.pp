# Install Nginx
package { 'nginx':
  ensure => installed,
}

# deploy static
$directories = [ '/data/', '/data/web_static/',
                        '/data/web_static/releases/', '/data/web_static/shared/',
                        '/data/web_static/releases/test/'
                  ]

# Create required directories
file { $directories:
  ensure  => 'directory',
  owner   => 'ubuntu',
  group   => 'ubuntu',
  recurse => 'remote',
  mode    => '0777',
}

# Create a fake HTML file for testing
file { '/data/web_static/releases/test/index.html':
  ensure  => present,
  content => 'A fake HTML file for testing',
}

# Create symbolic link to current release
file { '/data/web_static/current':
  ensure => link,
  target => '/data/web_static/releases/test/',
}

# Change ownership of the /data/ folder to the ubuntu user AND group
exec { 'chown -R ubuntu:ubuntu /data/':
  path => '/usr/bin/:/usr/local/bin/:/bin/'
}

# Configure Nginx
file_line {'deploy_static':
  path  => '/etc/nginx/sites-available/default',
  after => 'server_name _;',
  line  => "\n\tlocation /hbnb_static {\n\t\talias /data/web_static/current/;\n\t}",
}

# ensure nginx is running
service {'nginx':
  ensure  => running,
}

# Restart Nginx after updating the configuration
exec {'/etc/init.d/nginx restart':
}
