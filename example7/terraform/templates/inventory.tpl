[cfg]
%{ for node in unixway_mongodb["rs_cfg"]["nodes"] ~}
${ node["name"] } ansible_host=${ node["ip_public"] }
%{ endfor ~}

%{ for replica_set in keys(unixway_mongodb["rs_data"]) ~}
[${ replica_set }]
%{ for node in unixway_mongodb["rs_data"][replica_set]["nodes"] ~}
${ node["name"] } ansible_host=${ node["ip_public"] }
%{ endfor ~}
%{ endfor ~}

[lb]
%{ for node in unixway_load_balancer["nodes"] ~}
${ node["name"] } ansible_host=${ node["ip_public"] }
%{ endfor ~}

[mongos:children]
cfg
%{ for replica_set in keys(unixway_mongodb["rs_data"]) ~}
${ replica_set }
%{ endfor ~}
