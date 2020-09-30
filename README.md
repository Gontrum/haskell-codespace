# Haskell Codespace Image for using in VS Code and Codespaces

You can use the built Docker-Image provided at *davidgontrum/haskellcodespaces* to boot up a VS instance with Haskell support.

- Install the *Remote - Containers* Plugin (ms-vscode-remote.remote-containers) in VS Code
- Create a folder with the name `.devcontainer` inside your project folder"
- Inside `.devcontainer` create a file and name it `devcontainer.json`
- Paste following content to the new created file
```json
{
	"name": "GitHub Codespaces (Haskell)",
	"image": "davidgontrum/haskellcodespaces",
	"settings": {
		"terminal.integrated.shell.linux": "/bin/bash",
	},
	"remoteUser": "codespace",
	"overrideCommand": false,
	"workspaceMount": "source=${localWorkspaceFolder},target=/home/codespace/workspace,type=bind,consistency=cached",
	"workspaceFolder": "/home/codespace/workspace",
	"mounts": [ "source=/var/run/docker.sock,target=/var/run/docker-host.sock,type=bind" ],
	"runArgs": [ "--cap-add=SYS_PTRACE", "--security-opt", "seccomp=unconfined" ],

	"extensions": [
		"haskell.haskell",
		"k--kato.intellij-idea-keybindings",
		"GitHub.vscode-pull-request-github",
		"MS-vsliveshare.vsliveshare"
	]
}
```
- VS Code should recognize this and ask you, if you want to start your instance with a container

You could also publish your project with the .devcontainer folder to github and start a codespaces instance. You should now be able to develop haskell in your browser. 
