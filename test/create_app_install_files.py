import os
with open('../os/ubuntu/app_installapp_list.txt', 'r') as file:
    for app in file:
        app = app.rstrip()
        if ("#" in app) or (app == ""):
            continue
        app_file = "%s.sh" % app
        if not os.path.isfile(app_file):
            # f = open(app_file, 'w')
            f.write("#!/bin/bash\nsudo apt-get install -y %s" % app_file)
            f.close
        
        
