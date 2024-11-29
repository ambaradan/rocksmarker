<!-- vale off -->
# Rocksmarker

- [Neovim IDE for Markdown code](#neovim-ide-for-markdown-code)
    - [Purpose of the project](#purpose-of-the-project)
    - [Prerequisites for Neovim, Lua, and Rocksmarker](#prerequisites-for-neovim-lua-and-rocksmarker)
    - [Installation of Neovim](#installation-of-neovim)
    - [Installing Lua 5.1](#installing-lua-51)
        - [Version setting](#version-setting)
        - [Add headers files](#add-headers-files)
    - [Download the configuration](#download-the-configuration)
        - [Main Editor](#main-editor)
        - [Secondary editor](#secondary-editor)
    - [Installing the configuration](#installing-the-configuration)

## Neovim IDE for Markdown code

An **experimental** IDE project for writing documentation in Markdown code, the project uses the new plugin manager [rocks.nvim](https://github.com/nvim-neorocks/rocks.nvim).  
**Rocks.nvim** differs from previous plugin managers in its underlying philosophy, namely that the writing of the basic configuration (*dependencies*, *basic options* ...) is the developer's job and not the user's. This allows the end user to have an easier initial experience, advanced customization of plugins via configuration files always remains possible.  
Developers also set up an infrastructure for distributing plugins, which then are not downloaded from their respective projects but from the [luarocks](https://luarocks.org/modules/neorocks) portal; packages in this way are first tested and released. As a result, the release of new versions usually occurs later than the changes made to the projects.

## Purpose of the project

To provide as comprehensive an editor as possible for writing Markdown documentation for Rocky Linux, to this end the goals set are:

- Automatically set Neovim options for Markdown files
- Highlighting Markdown tags in the buffer
- Providing a zen mode for document editing
- Providing custom snippets for writing [mkdocs-material](https://squidfunk.github.io/mkdocs-material/) tags, snippets for standard Markdown tags are also provided.

## Prerequisites for Neovim, Lua, and Rocksmarker

> [!IMPORTANT]
> To install the *ninja-build* package, you must enable the [CRB repository](https://wiki.rockylinux.org/rocky/repo/#notes-on-crb) (CodeReady Linux Builder). The repository provides common tools for code development and in Rocky Linux you can enable it with the following commands:

```bash
sudo dnf install -y epel-release yum-utils
sudo dnf config-manager --set-enabled crb
```

You will need to install some packages to complete this project:

```bash
dnf install npm ncurses readline-devel icu ninja-build cmake gcc make unzip gettext curl glibc-gconv-extra tar git
```

## Installation of Neovim

For Rocksmarker, the recommendation is to use the source build of Neovim. You can follow those instructions from the "Quick start" at the [Neovim site here](https://github.com/neovim/neovim/blob/master/BUILD.md).

Compiling it from source presents no particular problems, and if the you meet the above requirements, it results in the following sequence of commands:

```bash
git clone https://github.com/neovim/neovim
cd neovim/
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
```

> [!NOTE]
> Using the *git checkout stable* command to place *git* in the stable branch before cloning, ensures the use of the stable version 0.10.2 (recommended). If omitted, the compilation will build the development branch 0.11.

## Installing Lua 5.1

The plugin manager chosen to configure additional Neovim plugins (**rocks.nvim**), requires the installation of the *Lua 5.1* version, and that it is the default version, to work properly. It is also necessary to link the *headers* files of version 5.1 to those on the system.  
One of the features of Lua, resulting from its development as an “embedded” language, is that it does not require any external dependencies. As a result, the various versions can coexist on the same system without conflicting. For example, a desktop installation of Rocky Linux 9 provides version 5.4.4.  
You can download the 5.1 version from the [official Lua site](https://www.lua.org/download.html) with the command:

```bash
curl -O https://www.lua.org/ftp/lua-5.1.5.tar.gz
```

Once downloaded, unpack it, and change inside the `lua-5.1.5` directory:

```bash
tar xzf lua-5.1.5.tar.gz
cd lua-5.1.5
```

Although you can perform the installation at the user level, in this configuration, choose the standard one (in `/usr/local/`), which allows for a cleaner subsequent configuration of the *headers* files.
You will need the *readline-devel* add-on package in the official repositories from Rocky Linux. It is in the prerequisites above.

> [!NOTE]
> The package takes this name in distributions derived from RHEL but in others identifies itself differently. Debian, for example, identifies it as *libreadline-dev*.

Compile and install the version with:

```bash
make linux test
sudo make install
```

The installation will copy the files to the following locations:

- **lua** **luac** -> `/usr/local/bin`
- **lua.h** **luaconf.h** **lualib.h** **lauxlib.h** **lua.hpp** -> `/usr/local/include`
- **liblua.a** -> `/usr/local/lib`

For its removal just delete the files listed above.

### Version setting

The system in use if installed as a desktop version will most likely already have a version of Lua installed that is the default. This version is unlikely to match the required version, so you will need to set it to point to the correct version.  
Using an *alias* in *.bashrc* you can tell the system the version you want. The string to add is as follows:

```bash
alias lua=/usr/local/bin/lua
```

Run the *source* with:

```bash
. ~/.bashrc
```

Verify version change with:

```bash
lua -v
Lua 5.1.5  Copyright (C) 1994-2012 Lua.org, PUC-Rio
```

### Add headers files

Installing the required version is not enough for the configuration to work properly. It is necessary to link the required library, *lua.h*, present in a `/usr/local/include/` in the *header* file search path (`/usr/include/`) otherwise it is not found by *luarocks* which takes care of the installation of the *rocks.nvim* plugin.
To accomplish this, you use one of the standard *Luarocks* search paths (`/usr/include/lua/<version_number>`). The *lua* folder is not present in a Rocky Linux system, and you will need to create it. Do this with:

```bash
cd /usr/include/
sudo mkdir lua && cd lua
sudo ln -s /usr/local/include/ 5.1
```

## Download the configuration

The configuration, although still under development, can be used daily for writing and editing documentation written in Markdown, so it can be installed as the default configuration in the `.config/nvim` path.  
For users who already have a Neovim configuration present on the system, there is the option of using *rocksmarker* as a secondary editor, thus allowing them to continue using their existing configuration for developing their projects.  
This method also allows you to try *rocksmarker*, completely independently, so that you can evaluate whether it might be a useful tool for your daily work.

### Main Editor

To install the configuration in the default Neovim location clone the GitHub repository to your configurations folder `~/.config/` with the command:

```bash
git clone https://github.com/ambaradan/rocksmarker.git ~/.config/nvim
```

Once finished, simply invoke the standard Neovim command to begin the installation:

```bash
nvim
```

### Secondary editor

To test or use the configuration as a secondary configuration use Neovim's variable *NVIM_APPNAME*, the use of this variable allows Neovim to pass an arbitrary name that is used for searching the configuration files in `~/.config/` and for the subsequent creation of the shared file folder in `~/.local/share/` and the cache in `~/.cache/`.  
To then set *rocksmarker* as a secondary editor type:

```bash
git clone https://github.com/ambaradan/rocksmarker.git ~/.config/rocksmarker/
```

Once the cloning operation is complete, start Neovim with the following command to begin the installation:

```bash
NVIM_APPNAME=rocksmarker nvim
```

> [!IMPORTANT]
> If you choose this method all subsequent startup of the configuration should be done using the command described above, otherwise Neovim will start using the default `~/.config/nvim` folder. To avoid typing the entire command each time, the creation of an *alias* is recommended.

## Installing the configuration

When Neovim starts, with either method described above, it will begin the installation process managed by a *bootstrap* script that checked for the lack of the *rocks.nvim* plugin and proceeded to install it.  
The first step of the installation consists of just installing the *rocks.nvim* plugin manager at the end of which, if everything worked properly, you will be asked to press ENTER to continue.  
The second step is to synchronize all the configured plugins, the synchronization installs the plugins in the shared files folder in the path `.local/share/nvim/rocks/lib/luarocks/rocks-5.1/`.

```text
:Rocks sync
```

Since the configuration includes some plugins not yet available for *luarocks* installed with the *git* method at the first synchronization you will receive related errors, these errors are resolved with a second synchronization, then close the editor, reopen it and repeat the synchronization:

```text
:Rocks sync
```

On the second startup, moreover, the *mason-lspconfig* and *mason-tool-installer* plugins installed during the first synchronization will take care, in a fully automatic way, of installing all the language servers (LSPs) necessary for the proper functioning of the configuration.

Close and reopen the editor to also load the configurations of plugins installed by way of *git* and you are ready to develop.

For a graphical overview of the editor, visit the [screenshots page](/docs/screenshots.md)
