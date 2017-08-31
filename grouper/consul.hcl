template {
  source = "/usr/src/app/templates/grouper-loader.properties.tmpl"
  destination = "/etc/grouper/loader.properties"
}

template {
  source = "/usr/src/app/templates/grouper-ws.properties.tmpl"
  destination = "/etc/grouper/grouper-ws.properties"
}

template {
  source = "/usr/src/app/templates/grouper.client.properties.tmpl"
  destination = "/etc/grouper/client.properties"
}

template {
  source = "/usr/src/app/templates/grouper.hibernate.properties.tmpl"
  destination = "/etc/grouper/hibernate.properties"
}

template {
  source = "/usr/src/app/templates/grouper.properties.tmpl"
  destination = "/etc/grouper/grouper.properties"
}

template {
  source = "/usr/src/app/templates/realm.properties.tmpl"
  destination = "/usr/src/app/realm.properties"
}

template {
  source = "/usr/src/app/templates/sources.xml.tmpl"
  destination = "/etc/grouper/sources.xml"
}

template {
  source = "/usr/src/app/templates/subject.properties.tmpl"
  destination = "/etc/grouper/subject.properties"
}
