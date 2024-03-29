import sys, json, urllib, getpass, zipfile, os


gnome_version = str(sys.argv[1])
gnome_version = gnome_version.split(".")
gnome_version = "%s.%s" % (gnome_version[0], gnome_version[1])

id_list = ["15", "6", "517", "442", "55", "104", "8", "352", "7", "792", "234", "1031", "307"]
# alternate-tab, applications-menu, caffeine, drop-down-terminal, media-player-indicator, netspeed, places-status-indicator, quick-close-in-overview, removable-drive-menu, shutdown-timer, steal-my-focus, topicons-plus, dash-to-dock

for id in id_list:
    url = "https://extensions.gnome.org/extension-info/?pk=%s&shell_version=%s" % (id, gnome_version)
    response = urllib.urlopen(url)
    data = json.loads(response.read())
    name = data['name']
    download_url = data['download_url']
    download_url = "https://extensions.gnome.org" + download_url
    uuid = data['uuid']
    if os.environ.has_key('SUDO_USER'):
        username = os.environ['SUDO_USER']
    else:
        username = os.environ['USER']
    fileName = "/home/%s/.temp/%s" % (username, id+".zip")
    downloadFile = urllib.URLopener()
    downloadFile.retrieve(url, fileName)
    targetDir = "/home/%s/.local/share/gnome-shell/extensions/%s" % (username, uuid)
    os.makedirs(targetDir)
    zip_ref = zipfile.ZipFile(fileName, 'r')
    zip_ref.extractall(targetDir)
    zip_ref.close()
    