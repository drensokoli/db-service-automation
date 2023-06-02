# DB Services Installer

This repository contains shell scripts that install different database services in Ubuntu, such as Pulsar, Kafka, MongoDB, Redis Server and more.

## Why this project?

This project is useful for anyone who wants to quickly set up and run various database services on their Ubuntu machine, without having to manually download, configure and install each service.

## How to use this project?

To use this project, you need to have a Ubuntu system with `curl` and `sudo` installed. Then, you can clone this repository or download the scripts you need from the `scripts` folder. Each script has a name that indicates the service it installs, such as `install-pulsar.sh` or `install-redis-server.sh`. To run a script, you need to make it executable with `chmod +x script-name.sh` and then execute it with `sudo ./script-name.sh`. The script will download and install the service and its dependencies, and start it as a background service. You can check the status of the service with `systemctl status service-name`.

## Where to get help?

If you encounter any issues or have any questions about this project, you can open an issue on this repository or contact me at drensokoli@gmail.com.

## Who maintains and contributes to this project?

This project is maintained by me, user B. I welcome any feedback, suggestions or contributions from other users. If you want to contribute to this project, please read the `CONTRIBUTING.md` file for guidelines.
