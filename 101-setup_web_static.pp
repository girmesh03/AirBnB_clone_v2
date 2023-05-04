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
  content => '<html><body>Test</body></html>',
}

# Create symbolic link to current release
file { '/data/web_static/current':
  ensure => link,
  target => '/data/web_static/releases/test/',
}

# Change ownership of the /data/ folder to the ubuntu user AND group
exec { 'chown':
  command => 'chown -R ubuntu:ubuntu /data/',
}

# Configure Nginx
file { '/etc/nginx/sites-available/default':
  content => "
server {

    listen 80 default_server;
    listen [::]:80 default_server;

    root   /var/www/html;
    index  index.html index.htm;

    location /hbnb_static {
        alias /data/web_static/current;
        index index.html index.htm;
    }

    location /redirect_me {
        return 301 https://www.facebook.com;
    }

    error_page 404 /404.html;

    location /404 {
      root /var/www/html;
      internal;
    }
}
",
  notify  => Service['nginx'],
}

# Restart Nginx after updating the configuration
service { 'nginx':
  ensure  => 'running',
  enable  => true,
  require => File['/etc/nginx/sites-available/default'],
}

exec {'/etc/init.d/nginx restart':
}
