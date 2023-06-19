# DB Services Installer

This repository contains shell scripts that install different database services in Ubuntu, such as Pulsar, Kafka, MongoDB, Redis Server and more.

## Why this project?

This project is useful for anyone who wants to quickly set up and run various database services on their Ubuntu machine, without having to manually download, configure and install each service.

## How to use this project?

To use this project, you need to have a Ubuntu system with `curl` and `sudo` installed. Then, you can clone this repository or download the scripts you need from the `scripts` folder. Each script has a name that indicates the service it installs, such as `install-pulsar.sh` or `install-redis-server.sh`. To run a script, you need to make it executable with `chmod +x script-name.sh` and then execute it with `sudo ./script-name.sh`. The script will download and install the service and its dependencies, and start it as a background service. You can check the status of the service with `systemctl status service-name`.

## Where to get help?

If you encounter any issues or have any questions about this project, you can open an issue on this repository or contact me at drensokoli@gmail.com.

## Contributors

<table>

  <tr>
    <td align="center">
      <img src="https://lh3.googleusercontent.com/a/AAcHTtdajMyHRDlLlen1AWkWzLWtOQ8AHOXi0vZBPvAL" width="140px;" alt=""/>
      <br />
      <sub><b>Dren Sokoli</b></sub>
      <br />
      <a href="https://www.linkedin.com/in/drensokoli/"> <img src="readme_assets/linkedin.png" height="20"></img>
      </a>
    </td>
    <td align="center">
      <img src="https://lh3.googleusercontent.com/a-/AD_cMMSpchbYEYWIPEFu4h69UIwwA4AiwwPw2Il3JE5W" width="140px;" alt=""/>
      <br />
      <sub><b>Ylber Gashi</b></sub>
      <br />
      <a href="https://github.com/ylber-gashi"><img src="readme_assets/linkedin.png" height="20"></a>
    </td>
  </tr>
</table>
