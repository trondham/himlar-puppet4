#
# Setup metric role with gnocchi
#
class profile::openstack::metric (
  $manage_firewall   = false,
  $firewall_extras   = {},
)  {

  include ::gnocchi
  include ::gnocchi::config
  include ::gnocchi::api
  include ::gnocchi::keystone::auth

  # wrappe disse i "manage_"-variabler
  include ::gnocchi::client
  include ::gnocchi::metricd
  include ::gnocchi::storage
  include ::gnocchi::storage::file
  include ::gnocchi::statsd

  if $manage_firewall {
    profile::firewall::rule { '123 metric api accept tcp':
      port        => 8000,
      proto       => 'tcp',
      destination => $::ipaddress_trp1,
      extras      => $firewall_extras,
    }
    profile::firewall::rule { '124 metricd accept iudp':
      port        => 8125,
      proto       => 'udp',
      destination => $::ipaddress_trp1,
      extras      => $firewall_extras,
    }
  }
}
