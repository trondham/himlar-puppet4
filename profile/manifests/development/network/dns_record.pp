#
define profile::development::network::dns_record(
  $use_dnsmasq = false
) {
  $vars = split($name, '\|')
  if $use_dnsmasq {
    host { $vars[0]:
      ip     => $vars[1],
      notify => $::runmode? { # notify dnsmasq only works in default runmode
        'default' => Class['dnsmasq::reload'],
        default   => undef }
    }
  } else {
    host { $vars[0]:
      ip => $vars[1]
    }
  }
}
