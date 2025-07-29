#  Toolkit

**Toolkit** is a modular, Linux-native command-line productivity suite designed for developers and power users. It includes multiple handy tools like quick code runners, reminders with background daemon support, modmap generators for different languages, snippet managers, and cleanup utilities — all in one repo.

---

##  Features

-  `remindme`: Add, list, remove time-based reminders with a background systemd daemon.
-  `quickrun`: Run code snippets quickly in C, C++, Java, Python, JS, and Shell.
-  `cleanup`: Clean up temporary files, logs, and cache.
-  `snippet`: Save, view, and manage your personal code snippets.
-  `modmap`: Generate template files for various programming languages (C, C++, Java, Python, JS, Shell).

---

##  Directory Structure
```
toolkit/
├── Modules/ # Language-specific modmap templates
├── commands/ # Main module scripts
├── data/ # Persistent storage (snippets, reminders, modmaps)
├── utils/ # (Optional) Logging or shared scripts
├── install.sh # Setup script with auto systemd service
├── toolkit.sh # Entry point for all modules
├── reminder-daemon.sh # Systemd-compatible daemon for reminders
├── modmap.sh # Central modmap handler
├── README.md # This file
├── reminder-daemon.service # The service file needed if you clone this repository  
```
---

## 🛠 Installation

You can install Toolkit in two ways:

###  Option 1: Clone the Repository

```bash
git clone https://github.com/cyberknighttron/toolkit.git
cd toolkit
chmod +x install.sh
./install.sh
```
 Option 2: Run Direct Install Script (Recommended)
```bash
 <(curl -s https://raw.githubusercontent.com/cyberknighttron/toolkit/main/install.sh)
```
##  Make Toolkit Commands Global
After cloning the repo manually and running the install script, you can make the toolkit command global (usable anywhere in terminal) by creating a symlink:

```bash
sudo ln -s ~/toolkit/toolkit.sh /usr/local/bin/toolkit
```
Replace ~/toolkit with your actual path if different.

##  Reminder Daemon Setup

Toolkit automatically installs a systemd service reminder-daemon.service to keep your reminders active in the background.

To manually enable/start the reminder daemon:

systemctl --user daemon-reexec

systemctl --user enable reminder-daemon.service

systemctl --user start reminder-daemon.service

Note: You must have systemd running and user session support (systemctl --user) for this to work.

# Usage Examples-

### Add a reminder-
remindme "Drink water in 10 minutes"

### Remove a specific reminder-
remindme --remove 1

### View all reminders-
remindme --list

### Run a C++ file-
quickrun hello.cpp

### Run a Python script-
quickrun script.py

### Add a snippet-
snippet --add

### View all snippets-
snippet --view

### Generate a C++ starter template-
modmap cpp myfile.cpp

### Run cleanup for logs, tmp, cache-
cleanup basic|full

#  Uninstall
To uninstall Toolkit:

rm -rf ~/.local/bin/toolkit

rm -rf ~/.local/bin/{remindme,quickrun,snippet,modmap,cleanup}

rm -rf ~/.config/systemd/user/reminder-daemon.service

systemctl --user disable reminder-daemon.service


GitHub: @cyberknighttron
