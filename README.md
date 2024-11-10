<-- vale off -->
# Neovim IDE for Markdown code

An **experimental** IDE project for writing documentation in Markdown code, the project uses the new plugin manager [rocks.nvim](https://github.com/nvim-neorocks/rocks.nvim).  
**Rocks.nvim** differs from previous plugin managers in its underlying philosophy, namely that the writing of the basic configuration (*dependencies*, *basic options* ...) is the developer's job and not the user's. This allows the end user to have an easier initial experience, advanced customization of plugins via configuration files always remains possible.  
Developers also set up an infrastructure for distributing plugins, which then are not downloaded from their respective projects but from the [luarocks](https://luarocks.org/modules/neorocks) portal; packages in this way are first tested and released. As a result, the release of new versions usually occurs later than the changes made to the projects.

## Purpose of the project

To provide as comprehensive an editor as possible for writing Markdown documentation for Rocky Linux, to this end the goals set are:

* Automatically set Neovim options for Markdown files
* Highlighting Markdown tags in the buffer
* Providing a zen mode for document editing
* Providing custom snippets for writing [mkdocs-material](https://squidfunk.github.io/mkdocs-material/) tags, snippets for standard Markdown tags are also provided.

## Prerequisites for Neovim, Lua, and Rocksmarker

You will need some packages to effectively complete compiling the packages in this project. Most will probably be on your system already, however this command should install anything that might be missing:

```bash
dnf install npm ncurses readline-devel icu ninja-build cmake gcc make unzip gettext curl glibc-gconv-extraz tar git
```

**NOTE:** To install the *ninja-build* package, you must enable the [CRB repository](https://wiki.rockylinux.org/rocky/repo/#notes-on-crb) (CodeReady Linux Builder). The repository provides common tools for code development and in Rocky Linux you can enable it with the following commands:

```bash
sudo dnf install -y epel-release yum-utils
sudo dnf config-manager --set-enabled crb
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

**NOTE:** Using the *git checkout stable* command to place *git* in the stable branch before cloning, ensures the use of the stable version 0.10.2 (recommended). If omitted, the compilation will build the development branch 0.11.

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

**Note:** The package takes this name in distributions derived from RHEL but in others identifies itself differently. Debian, for example, identifies it as *libreadline-dev*.

Compile and install the version with:

```bash
make linux test
sudo make install
```

The installation will copy the files to the following locations:

* **lua** **luac** -> `/usr/local/bin`
* **lua.h** **luaconf.h** **lualib.h** **lauxlib.h** **lua.hpp** -> `/usr/local/include`
* **liblua.a** -> `/usr/local/lib`

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
To accomplish this, you use one of the standard *Luarocks* search paths (`/usr/include/lua/<version_number>`). The *lua* folder is not present in a Rocky Linux system, and you will need to create it.  Do this with:

```bash
cd /usr/include/
sudo mkdir lua && cd lua
sudo ln -s /usr/local/include/ 5.1
```

## Installing the configuration

The configuration uses the project's bootstrap script **rocks.nvim** to install it, and requires no user intervention. To download the configuration, make a clone of the GitHub repository in your `.config` folder:

```bash
git clone https://github.com/ambaradan/rocksmarker.git ~/.config/rocksmarker/
```

### Starting the configuration ( test mode )

The start of the configuration is fully automatic. Running *Neovim*, the script contained in *init.lua* checks for the presence of the *rocks.nvim* plugin, and if absent, takes care of its installation by way of a *bootstrap* procedure. The only dependency required is the presence in the system paths of *Lua 5.1*.

It uses Neovim's `NVIM_APPNAME` variable to run an instance of it totally independent of the system configuration (`~/.config/nvim/`). In particular, the command uses the name *rocksmarker* for configuration folders, shared files and caches.

```bash
NVIM_APPNAME=rocksmarker nvim
```

Once the installation completes, the screen will show that some of the plugins in the configuration are missing. To install them, perform a *Sync*:

```txt
:Rocks sync
```

However, plugins configured by the traditional method (*Git*) are not installed during the first *Sync* as they are not versioned and generate a number of errors. These do not affect the installation of the *luarocks* ones. To fix them, you will need to close the editor, reopen it and re-run another `:Rocks sync` and then you will have all the configuration plugins installed and configured.

The restart also provides for automatic installation of the LSPs used by *nvim-lspconfig*. Their installation is displayed in the statusline. Use an autocommand For the missing LSPs (used by *conform* and *nvim-lint*) to take care of their installation:

```txt
:MasonInstallAll
```

Close and reopen the editor to also load the configurations of plugins installed by way of *git* and you are ready to develop.
