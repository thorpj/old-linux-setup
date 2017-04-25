import os
for file in os.listdir("../os/ubuntu/app_install/"):
    app = file.split('.')
    app = app[0]
    if file.endswith(".sh"):
        if os.stat(file).st_size == 0:
            with open("../os/ubuntu/app_install/%s" % file, 'w') as file:
                file.write("#!/bin/bash\nsudo apt-get install -y %s" % app)