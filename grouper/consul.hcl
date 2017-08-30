template {
  source = "templates/grouper-loader.properties.tmpl"
  destination = "/etc/grouper/loader.properties"
}

template {
  source = "templates/grouper-ws.properties.tmpl"
  destination = "/etc/grouper/grouper-ws.properties"
}

template {
  source = "templates/grouper.client.properties.tmpl"
  destination = "/etc/grouper/client.properties"
}

template {
  source = "templates/grouper.hibernate.properties.tmpl"
  destination = "/etc/grouper/hibernate.properties"
}

template {
  source = "templates/grouper.properties.tmpl"
  destination = "/etc/grouper/grouper.properties"
}

template {
  source = "templates/realm.properties.tmpl"
  destination = "/usr/src/app/realm.properties"
}

template {
  source = "templates/sources.xml.tmpl"
  destination = "/etc/grouper/sources.xml"
}

template {
  source = "templates/subject.properties.tmpl"
  destination = "/etc/grouper/subject.properties"
}
