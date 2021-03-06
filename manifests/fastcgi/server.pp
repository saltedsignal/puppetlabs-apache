define apache::fastcgi::server (
  $host          = '127.0.0.1:9000',
  $timeout       = 15,
  $flush         = false,
  $faux_path     = "/var/www/${name}.fcgi",
  $fcgi_alias    = "/${name}.fcgi",
  $file_type     = 'application/x-httpd-php',
  $pass_header   = undef,
) {
  include ::apache::mod::fastcgi

  Apache::Mod['fastcgi'] -> Apache::Fastcgi::Server[$title]

  if $host =~ Stdlib::Absolutepath {
    $socket = $host
  }

  file { "fastcgi-pool-${name}.conf":
    ensure  => file,
    path    => "${::apache::confd_dir}/fastcgi-pool-${name}.conf",
    owner   => 'root',
    group   => $::apache::params::root_group,
    mode    => $::apache::file_mode,
    content => template('apache/fastcgi/server.erb'),
    require => Exec["mkdir ${::apache::confd_dir}"],
    before  => File[$::apache::confd_dir],
    notify  => Class['apache::service'],
  }
}
