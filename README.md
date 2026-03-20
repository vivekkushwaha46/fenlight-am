# FenLight Optimized (Android TV)

This repository hosts a highly optimized version of the Fen Light Kodi addon, tailored specifically for low-resource environments such as older Android TVs and Firesticks. Memory overhead has been dramatically reduced, and CPU cycles have been simplified to ensure swift directory loading capabilities.

## Repository Setup (For Maintainers)

To distribute this addon to your friends, you need to enable GitHub Pages for this repository:
1. Go to your repository **Settings** on GitHub.
2. Navigate to the **Pages** section on the left sidebar.
3. Under **Build and deployment > Source**, select **Deploy from a branch**.
4. In the **Branch** dropdown, select `main` (or your default branch) and the `/ (root)` folder constraint.
5. Click **Save**.

Your repository will now be hosted at `https://<my-username>.github.io/<repo-name>/`.

## Build Instructions (For Maintainers)

Whenever you make changes to the addon's source code in `packages/plugin.video.fenlight/`, you must package it before updating the repository:

1. Open your terminal and navigate to the root of this repository.
2. Ensure the bash script is executable (only needed once):
   ```bash
   chmod +x release.sh
   ```
3. Run the automated release script:
   ```bash
   ./release.sh
   ```
4. Commit the generated files located in the `repo/` directory:
   ```bash
   git add repo/
   git commit -m "Update FenLight optimized addon"
   git push origin main
   ```

## User Installation Guide

To install this addon on Kodi, follow these steps to add the repository and install the optimized Fen Light:

### 1. Add the Repository Source
1. Open up Kodi and navigate to **Settings** (the gear icon at the top left).
2. Go to **File manager** -> **Add source**.
3. Click on `<None>` and enter the following URL precisely:
   `https://<my-username>.github.io/<repo-name>/repo/` *(Replace with your actual GitHub Pages URL)*
4. Name the media source (e.g., `FenLight Repo`) and click **OK**.

### 2. Install the Repository ZIP
1. Go back to the Kodi home screen and select **Add-ons**.
2. Click the **Add-on browser** box icon at the top left.
3. Select **Install from zip file**. (If prompted, briefly enable "Unknown sources" in your Kodi Settings).
4. Choose the source you named earlier (`FenLight Repo`).
5. Open the `plugin.video.fenlight/` folder and select the zip file (e.g., `plugin.video.fenlight-2.1.90.zip`).
6. Wait for the "Add-on installed" pop-up notification.

### 3. Verify the Add-on
1. The Add-on should directly appear within your main screen context items under **My add-ons > Video add-ons**.
2. Ensure you apply any account configurations needed (e.g Trakt / Debrid authorizations) within the app settings.

Enjoy your heavily optimized streaming experience!
