# Install Nginx
package { 'nginx':
  ensure => installed,
}

# Create required directories
file { ['/data', '/data/web_static', '/data/web_static/releases', '/data/web_static/shared', '/data/web_static/releases/test']:
  ensure => directory,
}

# Create a fake HTML file for testing
file { '/data/web_static/releases/test/index.html':
  content => '<html><body>Test</body></html>',
}

# Create symbolic link to current release
file { '/data/web_static/current':
  ensure  => 'link',
  target  => '/data/web_static/releases/test',
  require => File['/data/web_static/releases/test'],
  before  => Service['nginx'],
}

# Give ownership to the ubuntu user and group
file { '/data':
  owner   => 'ubuntu',
  group   => 'ubuntu',
  recurse => true,
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
