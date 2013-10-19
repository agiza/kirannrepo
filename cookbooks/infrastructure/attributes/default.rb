# Entries for deployment attributes
default["app_names"] = "rd-adm-print-recon-adapter|adm_recon_version|realdoc-adapter rd-hov-print-recon-adapter|hov_recon_version|realdoc-adapter rd-walz-print-recon-adapter|walz_recon_version|realdoc-adapter realfoundation|realfoundation_version|realfoundation realtrans-central|realtranscentral_version|realtrans-server realtrans-fp|realtransfp_version|realtrans-server realtrans-vp|realtransvp_version|realtrans-server realtrans-reg|realtransreg_version|realtrans-server int-corelogic|intcorelogic_version|l1-int int-datavision|intdatavision_version|l1-int int-etrac|intetrac_version|l1-int int-interthinx|intinterthinx_version|l1-int int-realservicing|intrs_version|realtrans-int int-realresolution|intrres_version|realtrans-int realdoc|realdoc_version|realdoc-server strongmail-adapter|smadapter_version|realdoc-adapter jdbc-data-provider|jdbcprov_version|realdoc-adapter realsvc-recon-adapter|reconadapter_version|realdoc-adapter int-collateralanalytics|intca_version|realtrans-int int-support|intsupport_version|realtrans-int l1-central|l1central_version|l1-server l1-rp|l1rp_version|l1-server l1-fp|l1fp_version|l1-server replication-app|repapp_version|rsng-server rsng-service-app|rsngapp_version|rsng-server hubzu-backoffice|hubzubo_version|hubzu-backoffice rd-correspondence|rdcorr_version|realdoc-corr rd-transcentra-recon-adapter|rdtranscentrarecon_version|realdoc-adapter rd-proxy-image-generator|rdproxygen_version|realdoc-proxy rd-mailmerge-adapter|rdmailmerge_version|realdoc-adapter realservicing-correspondence-adapter|rdcorradap_version|realdoc-adapter"
# New sttructure to replace app_names and it ain't it purdier
default[:apps] = [
    {
        :name => 'rd-adm-print-recon-adapter',
        :version => 'adm_recon_version',
        :recipe => 'realdoc-adapter'
    }, {
        :name => 'rd-hov-print-recon-adapter',
        :version => 'hov_recon_version',
        :recipe => 'realdoc-adapter'
    }, {
        :name => 'rd-walz-print-recon-adapter',
        :version => 'walz_recon_version',
        :recipe => 'realdoc-adapter'
    }, {
        :name => 'realfoundation',
        :version => 'realfoundation_version',
        :recipe => 'realfoundation'
    }, {
        :name => 'realtrans-central',
        :version => 'realtranscentral_version',
        :recipe => 'realtrans-server'
    }, {
        :name => 'realtrans-rp',
        :version => 'realtransrp_version',
        :recipe => 'realtrans-server'
    }, {
        :name => 'realtrans-fp',
        :version => 'realtransfp_version',
        :recipe => 'realtrans-server'
    }, {
        :name => 'realtrans-vp',
        :version => 'realtransvp_version',
        :recipe => 'realtrans-server'
    }, {
        :name => 'realtrans-reg',
        :version => 'realtransreg_version',
        :recipe => 'realtrans-server'
    }, {
        :name => 'int-corelogic',
        :version => 'intcorelogic_version',
        :recipe => 'l1-int'
    }, {
        :name => 'int-datavision',
        :version => 'intdatavision_version',
        :recipe => 'l1-int'
    }, {
        :name => 'int-etrac',
        :version => 'intetrac_version',
        :recipe => 'l1-int'
    }, {
        :name => 'int-interthinx',
        :version => 'intinterthinx_version',
        :recipe => 'l1-int'
    }, {
        :name => 'int-realservicing',
        :version => 'intrs_version',
        :recipe => 'realtrans-int'
    }, {
        :name => 'int-realresolution',
        :version => 'intrres_version',
        :recipe => 'realtrans-int'
    }, {
        :name => 'realdoc',
        :version => 'realdoc_version',
        :recipe => 'realdoc-server'
    }, {
        :name => 'strongmail-adapter',
        :version => 'smadapter_version',
        :recipe => 'realdoc-adapter'
    }, {
        :name => 'jdbc-data-provider',
        :version => 'jdbcprov_version',
        :recipe => 'realdoc-adapter'
    }, {
        :name => 'realsvc-recon-adapter',
        :version => 'reconadapter_version',
        :recipe => 'realdoc-adapter'
    }, {
        :name => 'int-collateralanalytics',
        :version => 'intca_version',
        :recipe => 'realtrans-int'
    }, {
        :name => 'int-support',
        :version => 'intsupport_version',
        :recipe => 'realtrans-int'
    }, {
        :name => 'l1-central',
        :version => 'l1central_version',
        :recipe => 'l1-server'
    }, {
        :name => 'l1-rp',
        :version => 'l1rp_version',
        :recipe => 'l1-server'
    }, {
        :name => 'l1-fp',
        :version => 'l1fp_version',
        :recipe => 'l1-server'
    }, {
        :name => 'replication-app',
        :version => 'repapp_version',
        :recipe => 'rsng-server'
    }, {
        :name => 'rsng-service-app',
        :version => 'rsngapp_version',
        :recipe => 'rsng-server'
    }, {
        :name => 'hubzu-backoffice',
        :version => 'hubzubo_version',
        :recipe => 'hubzu-backoffice'
    }, {
        :name => 'rd-correspondence',
        :version => 'rdcorr_version',
        :recipe => 'realdoc-corr'
    }, {
        :name => 'rd-transcentra-recon-adapter',
        :version => 'rdtranscentrarecon_version',
        :recipe => 'realdoc-adapter'
    }, {
        :name => 'rd-proxy-image-generator',
        :version => 'rdproxygen_version',
        :recipe => 'realdoc-proxy'
    }, {
        :name => 'rd-mailmerge-adapter',
        :version => 'rdmailmerge_version',
        :recipe => 'realdoc-adapter'
    }, {
        :name => 'realservicing-correspondence-adapter',
        :version => 'rdcorradap_version',
        :recipe => 'realdoc-adapter'
    }, {
        :name => 'realservicing-correspondence-adapter-tp2',
        :version => 'tp2_adapter_version',
        :recipe => 'realdoc-adapter'
    }
]
default["vsftp"] = {
    :usernames => []
}
