import sys, json, urllib, getpass, zipfile, os

extension_version = str(sys.argv[1])

id_list = ["15", "6", "517", "442", "55", "104", "8", "352", "7", "792", "234", "1031", "307"]
# alternate-tab, applicaitons-menu, caffeine, drop-down-terminal, media-player-indicator, netspeed, places-status-indicator, quick-close-in-overview, removable-drive-menu, shutdown-timer, steal-my-focus, topicons-plus, dash-to-dock

for id in id_list:
    url = "https://extensions.gnome.org/extension-info/?pk=%s&shell_version=%s" % (id, extension_version)
    response = urllib.urlopen(url)
    data = json.loads(response.read())
    name = data['name']
    download_url = data['download_url']
    download_url = "https://extensions.gnome.org" + download_url
    uuid = data['uuid']
    username = getpass.getuser()
    fileName = "/home/%s/.temp/%s" % (username, id+".zip")
    downloadFile = urllib.URLopener()
    downloadFile.retrieve(url, fileName)
    targetDir = "/home/%s/.local/share/gnome-shell/extensions/%s" % (username, uuid)
    os.makedirs(targetDir)
    zip_ref = zipfile.ZipFile(fileName, 'r')
    zip_ref.extractall(targetDir)
    zip_ref.close()