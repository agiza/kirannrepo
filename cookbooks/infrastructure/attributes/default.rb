# New sttructure to replace app_names and ain't it purdier
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
        :name => 'hubzu-accounts',
        :version => 'hubzuac_version',
        :recipe => 'hubzu-accounts'
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
    }, {
        :name => 'int-realservicing-simulator',
        :version => 'intrs_sim_version',
        :recipe => 'int-realservicing-simulator'
    }, {
        :name => 'int-rtlegacy',
        :version => 'intrtl_version',
        :recipe => 'int-rtlegacy'
    }, {
        :name => 'int-rtlegacy-simulator',
        :version => 'intrtl_sim_version',
        :recipe => 'int-rtlegacy-simulator'
    }
]
default["vsftp"] = {
    :usernames => []
}
default[:infrastructure][:rpmforge][:version] = "0.5.3-1.el6.rf"
default[:infrastructure][:rpmforge][:gpg_key] = "#{Chef::Config[:file_cache_path]}/rpmforge-RPM-GPG-KEY.dag.txt"
