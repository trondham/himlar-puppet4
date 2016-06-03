# Manage config file for himlar cli
class profile::application::himlarcli(
  $username,
  $password,
  $tenant_name,
  $default_domain,
  $region_name,
  $auth_url,
  $foreman_url,
  $foreman_password,
  $foreman_user,
  $smtp,
  $from_addr,
  $cacert = undef
) {

  file { '/etc/himlarcli':
    ensure => directory
  } ->
  file { '/etc/himlarcli/config.ini':
    ensure => file,
    content => template("${module_name}/application/himlarcli/config.ini.erb"),
  }
}
