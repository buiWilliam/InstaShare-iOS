# InstaShare-iOS
To Run the application
1. Open the project workspace "InstaShare.workspace"
2. Plug in Testing Device
3. Choose connected device as the location to deploy the application.
4. Change the baseURl in the loginView, signupView, contactTableView,galleryView,photoView.
5. Run

Some known Bugs and temporary fix:
1. Application is making a put request first time a contact was uploaded
    Solution: Check the application container to see if phone's local database matches up with the servers.
2. Application camera is hung.
    Solution: Do one run using the gallery feature to refresh the camera
