


# Setup {#setup}

This chapter will take you through all steps necessary to fully setup your computer. There are several things we need to do:

 1. First, in section \@ref(setup-install) we will install both R and Rstudio.
 2. Next, in section \@ref(setup-packs-config) we will install some necessary R packages and configure some recommended Rstudio settings.
 3. Finally, in section \@ref(setup-files) we will setup an organization system for your files.




## R/Rstudio setup {#setup-install}


We will be using both R and Rstudio throughout the course.


 - [R](https://www.r-project.org) is a free and open-source statistical computing software.
 - [Rstudio](https://posit.co/products/open-source/rstudio) is an IDE (integrated development environment) that makes developing in R much easier.
   - If you prefer, you can also use a different IDE like [Visual Studio](https://code.visualstudio.com/docs/languages/r) or [Jupyter](https://docs.anaconda.com/free/navigator/tutorials/r-lang).


::: {.note}
R and Rstudio are two different programs that both need to be installed! Also, if you have previously installed R or Rstudio, it is highly recommended to first completely uninstall it before reinstalling the latest version to avoid conflicts (instructions for [Windows](https://www.pcmag.com/how-to/how-to-uninstall-programs-in-windows-10) and [Mac](https://support.apple.com/en-us/102610)).
:::


First, we will install the latest R release, **version 4.5.1 released on Jun 13, 2025**; then we will install Rstudio. The instructions below are separated by operating system, depending on if you have a [Windows](#setup-win) or [Mac](#setup-mac) machine.

 - If you have a Linux system, follow one of the linked instructions [here](https://cloud.r-project.org/bin/linux).
 - If you have a Chromebook, try [these steps](https://levente.littvay.hu/chromebook).




### Windows instructions {#setup-win}


 1. Download [R-4.5.1-win.exe](https://cloud.r-project.org/bin/windows/base/old/4.5.1/R-4.5.1-win.exe) and run it, accepting all default settings.
 
 2. Download [Rstudio-latest.exe](	https://rstudio.org/download/latest/stable/desktop/windows/RStudio-latest.exe) and run it, again accepting all default settings.
 
 3. Sometimes, R may need to recompile a package during installation, which will require the Rtools utility. To download the right version, check your system's [about page](ms-settings:about) and look at the "System type" line.
    - If it shows "... x64-based processor", download this [Rtools installer](https://cran.r-project.org/bin/windows/Rtools/rtools44/files/rtools44-6459-6401.exe) and run it, accepting all default settings.
    - If it shows "... ARM-based processor", download this [Rtools installer](https://cran.r-project.org/bin/windows/Rtools/rtools44/files/rtools44-aarch64-6459-6401.exe) and run it, accepting all default settings.

Now, you should have both R and Rstudio setup. To check the installation, find "Rstudio" in your start menu and run it. If asked to choose an installation, just accept the default and click OK.

If you get a window that looks [like this](https://i.imgur.com/qmt5IHj.png), you're all set and are ready to move on to the [next section](#setup-packs-config)!




### Mac instructions {#setup-mac}


 1. First, we need to determine the right R installer file for your specific machine. Open the Apple menu in the top left corner of your screen and open ["About this mac"](https://upload.wikimedia.org/wikipedia/en/a/a6/Apple_menu_screenshot.png).
    - If it shows "Chip: Apple M1/M2/M3", download [R-4.5.1-arm64.pkg](https://cloud.r-project.org/bin/macosx/big-sur-arm64/base/R-4.5.1-arm64.pkg) and run it, accepting all default settings.
    - If it shows "Processor: ...Intel Core", download [R-4.5.1-x86_64.pkg](https://cloud.r-project.org/bin/macosx/big-sur-x86_64/base/R-4.5.1-x86_64.pkg) and run it, accepting all default settings.
    - If you get an error, check your OS version in the About window. If it's older (i.e. <11) you may need to either upgrade your OS or download an older version [here](https://cloud.r-project.org/bin/macosx).
    
 2. Now, download [Rstudio-latest.dmg](https://rstudio.org/download/latest/stable/desktop/mac/RStudio-latest.dmg) and install it. Note this is a dmg or virtual disk image file, so you need to follow these steps to install it:
    a. Double click the file to open it. This will mount a virtual drive to your desktop and then open it in a new Finder window.
    b. In the new window, drag the Rstudio icon into the Applications directory. This will install it to your computer.
    c. Open a new Finder window, go to the Applications directory, find the new Rstudio program and drag it into your dock for easy access.
    d. (Optional) You can now unmount the virtual disk. Right click the mounted virtual disk on your desktop and choose "Unmount", or alternatively find the mounted drive on the right side of your dock and drag it to the trash bin. You can also delete the .dmg install file.

<!--https://i.imgur.com/1NMFdL9.jpeg-->
    
 3. On many (but not all) systems, two additional programs need to be installed for everything to run smoothly. It is recommended for everyone to install these just in case (there's no harm if you didn't actually need them).
    a. Download [XQuartz-2.8.5.pkg](https://github.com/XQuartz/XQuartz/releases/download/XQuartz-2.8.5/XQuartz-2.8.5.pkg) and run it, accepting all default settings. This installs a tool that Rstudio uses to display certain outputs.
    b. Using either Spotlight, Launchpad, or the Applications directory, open "Terminal" and type in or copy this line `xcode-select --install`{.zsh} and hit enter, then follow on-screen instructions. You may be asked for your fingerprint or password (note your password will not show as you type, this is normal and done for security purposes).

On some machines, R or Rstudio may be blocked by your OS out of an overabundance of caution. Follow [these steps](https://support.apple.com/en-us/102445#openanyway) to unblock and then try again.


Now, assuming everything went smoothly, you should have both R and Rstudio setup. To check the installation, find "Rstudio" in your Dock or Applications directory and run it. If asked to choose an installation, just accept the default and click OK.


If you get a window that looks [like this](https://i.imgur.com/qmt5IHj.png), you're all set!




## Packages/config {#setup-packs-config}


::: {.note}
Before continuing, make sure that you can [open Rstudio](https://i.imgur.com/qmt5IHj.png) and have the correct version (R-4.5.1) installed!
:::

Next, we will install some necessary packages and configure some recommended options to improve workflow.


 1. Open Rstudio. In the Console window, type in or copy this line `install.packages(c("tidyverse","rmarkdown"))`{.R} and hit enter.
    - If Rstudio asks you whether to "use a personal library", choose yes.
    - If Rstudio asks you whether to "install from source", first try choosing no which should work for most people. If that fails, try repeating step 1, but this time choose yes.  
    
    Make sure you see either "successfully unpacked" or "downloaded binary packages are in" in the console messages to confirm installation succeeded.
    
 2. Next, from the menu bar at the top, go to "Tools" > "Global Options".
    a. On this first page, under the ["Workspace" section](https://i.imgur.com/Of5lBYT.png), set the following:
       i.  Turn off "Restore .RData into workspace at startup"
           - This ensures every time we close and reopen Rstudio that we start with a fresh session uncluttered with junk from previous sessions.
       ii. Change "Save workspace to .Rdata on exit:" to "Never"
           - This stops Rstudio from asking you during shutdown if you want to save your session, also preventing clutter.
    b. Next, on the ["R Markdown" page](https://i.imgur.com/HjuJ0hm.png) of the Options window, set the following:
       i.  Change "Show output preview in:" to "Viewer Pane"
           - This improves workflow by displaying plots in the Viewer pane instead of opening a new window.
       ii. Turn off "Show output inline for all R Markdown documents"
           - This also improves workflow by displaying output in the console instead of inline in documents.
    c. (Optional) If you wish to customize the interface, you can go to the ["Appearance" page](https://i.imgur.com/WsnSWNM.png) and change your font or theme.^[If you like working in the dark and have an OLED-screen, you may want to check out the [synthwaveBLACK](https://github.com/roshandarji/synthwaveBLACK) theme.]
    d. Press OK to save your changes.  
    
    There are LOTS of other options you can feel free to explore later on your own, but for now we will move on.
    
 3. Due to poor design, we need to repeat the previous R Markdown configuration steps again because Rstudio duplicates these settings in another menu.
    a. From the menu bar at the top, go to "File" > "New File" > "R Markdown". Ignore the options in the new window and click "OK" to create a new R Markdown file (we will learn more about R Markdown files later).
    b. In the new editor pane, open the [gear-icon dropdown menu](https://i.imgur.com/yr0jdxa.png) and make sure to reselect the same options (highlighted in red).

Now your R/Rstudio should be properly setup.




## File organization {#setup-files}


There will be a lot of files to keep track of in this course, so it is highly recommended you create a neat directory structure on your computer to help organize your files. We recommend a directory structure similar to this:

:::{.paths}
    ..
    └── STAT240/
        ├── data/
        ├── discussion/
        │   ├── ds01/
        │   ├── ds02/
        │   ├── ds03/
        │   :    :
        ├── homework/
        │   ├── hw01/
        │   ├── hw02/
        │   ├── hw03/
        │   :    :
        ├── notes/
        └── project/
:::

:::{.note}
"Directory" is synonymous with "folder". In technical spaces, "directory" is often the preferred term.
:::


This tree diagram shows somewhere in your computer ("..") you should make a "STAT240" directory. Inside, you should have directories like "homework" and "discussion" with a subdirectory for each specific assignment (e.g. "hw01", "hw02", "ds01", "ds02", etc..).

We also recommend creating directories "data", where you should place all the datasets you download; "notes", where you can place any other notes you download or take; and "project", where you can place your project files when those are assigned later. If necessary, you can also create further directories at your own discretion.

:::{.note}
Make sure your STAT240 directory is NOT backed up by a cloud synchronized app like OneDrive, Box, or iCloud. These programs sometimes interfere with R/Rstudio and may also cut off larger datasets.

We recommend you pick a different parent directory ("..") than "Desktop" or "Documents" since these are often backed up by default on many modern systems. A good alternative is either the "Downloads" directory which is usually not backed up, or your user's home directory (instructions for [Windows](https://www.addictivetips.com/windows-tips/access-the-user-folder-on-windows-10) and [Mac](https://www.cnet.com/tech/computing/how-to-find-your-macs-home-folder-and-add-it-to-finder)).

After creation, you can make this directory more convenient to access by [making a shortcut](https://support.motlow.edu/TDClient/274/Portal/KB/ArticleDet?ID=12451) on your desktop, or pinning it to somewhere accessible like [Quick Access](https://www.pcmag.com/how-to/how-to-retrieve-folders-files-with-windows-10-quick-access) for Windows or your [Dock](https://www.howtogeek.com/712237/how-to-pin-a-folder-or-a-file-to-your-macs-dock) for Macs.
:::




## Setup troubleshooting FAQ


\*\*FAQ will be added here as we collect more commonly encountered problems\*\*
