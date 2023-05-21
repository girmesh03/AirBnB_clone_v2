# Install Nginx
package { 'nginx':
  ensure => installed,
}

# Create required directories
file { [
  '/data',
  '/data/web_static',
  '/data/web_static/releases',
  '/data/web_static/shared',
  '/data/web_static/releases/test',
]:
  ensure  => 'directory',
  owner   => 'ubuntu',
  group   => 'ubuntu',
  mode    => '0755',
  recurse => true,
}

# Create a fake HTML file for testing purposes
file { '/data/web_static/releases/test/index.html':
  content => '<html><head><\head><body>Testing Nginx configuration</body></html>',
  owner   => 'ubuntu',
  group   => 'ubuntu',
  mode    => '0644',
}

# Create a symbolic link
file { '/data/web_static/current':
  ensure => 'link',
  target => '/data/web_static/releases/test',
  owner  => 'ubuntu',
  group  => 'ubuntu',
  mode   => '0755',
  force  => true,
}

# Update Nginx configuration
file { '/etc/nginx/sites-available/default':
  content => "
    server {
        listen 80;
        listen [::]:80;
        server_name localhost;

        location /hbnb_static {
            alias /data/web_static/current/;
        }
    }
  ",
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  notify  => Service['nginx'],
}

# Restart Nginx after updating configuration
service { 'nginx':
  ensure  => 'running',
  enable  => true,
  require => File['/etc/nginx/sites-available/default'],
}
