# SFTP Sync Action

Uses [lftp](https://lftp.yar.ru/) to mirror path in repository to an SFTP server using SSH key for authentication.

## Inputs

```yml
  server:
    description: "server"
    required: true
  port:
    description: "server port (default: 22)"
    required: true
    default: 22
  user:
    description: "user"
    required: true
  user_private_key:
    description: "Private SSH key for user (include via secrets if possible)"
    required: true
  host_public_key:
    description: "Public SSH key of host"
    required: true
    default: ""
  local:
    description: "Local path to sync (default: .)"
    required: true
    default: .
  remote:
    description: "Path on server (default: .)"
    required: true
    default: .
  ssh_options:
    description: "Additional options for SSH"
    required: false
  mirror_options:
    description: "Additional options for lftp mirror command (e.g. '--exclude-glob=.git*/ --verbose' is useful)"
    required: false
```

See [lftp man-page](https://lftp.yar.ru/lftp-man.html) for options of the lftp `mirror` command.


## Example

```yml
on: [push]

jobs:
  upload_to_sftp:
    name: deploy
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: SFTP Sync
        uses: swillner/sftp-sync-action@v1.0
        with:
          server: my-ssh-server.com
          user: myuser
          user_private_key: "${{ secrets.USER_PRIVATE_KEY }}"
          host_public_key: "ssh-rsa ACTUALKEYCONTENTHERE"
          remote: /home/myuser/upload
          mirror_options: "--exclude-glob=.git*/ --verbose"
```
