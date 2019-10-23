

# Disable DNS systemd
# https://askubuntu.com/questions/907246/how-to-disable-systemd-resolved-in-ubuntu

ct_systemdDisableDNS() {
    sudo systemctl disable systemd-resolved.service
    sudo service systemd-resolved stop

    /etc/NetworkManager/NetworkManager.conf
    rm /etc/resolv.conf
    sudo service network-manager restart
}

ct_systemdListaServicosHabilitados() {
    #systemctl list-unit-files | grep enabled
    systemctl list-unit-files --state=enabled
}

ct_systemdListaRunning() {
    #systemctl | grep running
    systemctl list-units --type=service --state=running
}

ct_systemdRunningAndFail(){
    systemctl list-units --type service --state running,failed
}