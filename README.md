<!-- vale off -->
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

## Installing Lua 5.1

The plugin manager chosen (**rocks.nvim**) for configuring additional Neovim plugins requires that the *Lua 5.1* version be installed on the system to work properly. This, however, does not require a global installation but can be installed at the user level; cohabitation with other versions (Rocky Linux provides 5.4.4) creates no conflict.

For its installation the program [luaver](https://github.com/DhavalKapil/luaver) is used, this utility allows automatic installation of the various versions of *Lua* and their setup in the system.  
Luaver requires the *make* and *wget* or *curl* software packages, all normally available in a Rocky system, and an additional *readline-devel* package, available from the official repositories, to install it:

```bash
sudo dnf install readline-devel
```

Now to install *luaver* run the command:

```bash
curl -fsSL https://raw.githubusercontent.com/dhavalkapil/luaver/master/install.sh | sh -s - -r v1.1.0
```

As suggested by the installation, run a *source*:

```bash
. ~/.bashrc
```

To verify that everything has been installed correctly type:

```bash
luaver version
Lua Version Manager 1.1.0

Developed by Dhaval Kapil <me@dhavalkapil.com>
```

This utility allows you to do numerous operations on both versions of *Lua* and *Luarocks* and *LuaJIT*, for its reference you can use the `luaver help` command.

To install Lua version 5.1:

```bash
luaver install 5.1
```

Luaver will download the required version and proceed to compile and install it; the installation is performed in the user's `.luaver` folder.

```txt

.luaver/
├── completions
│   └── luaver.bash
├── lua
│   └── 5.1
├── luajit
├── luarocks
├── luaver
└── src
    └── lua-5.1
```

At this point we need to provide the system with which version to use with:

```bash
luaver use 5.1
```

The version used can be controlled with:

```bash
lua -v
Lua 5.1  Copyright (C) 1994-2006 Lua.org, PUC-Rio
```

Now for the entire session the terminal will use Lua version 5.1, the setting however is lost with the closing of the session and to have a permanent setting the command is used:

```bash
luaver set-default 5.1
```

## Installing the configuration

The configuration uses the project's bootstrap script **rocks.nvim** to install it, and requires no user intervention. To download the configuration, simply make a clone of the GitHub repository in your `.config` folder

```bash
git clone https://github.com/ambaradan/rocksmarker.git ~/.config/rocksmarker/
```

### Starting the configuration ( test mode )

The start of the configuration is fully automatic, running *Neovim* the script contained in *init.lua* checks for the presence of the *rocks.nvim* plugin and if absent takes care of its installation via a *bootstrap* procedure, the only dependency required is the presence in the system paths of *Lua 5.1*.

It uses Neovim's `NVIM_APPNAME` variable to run an instance of it totally independent of the system configuration (`~/.config/nvim/`). In particular, the command uses the name *rocksmarker* for configuration folders, shared files and caches.

```bash
NVIM_APPNAME=rocksmarker nvim
```

Once the installation is finished, the screen will show that some of the plugins in the configuration are missing, to install them perform a *Sync*:

```txt
:Rocks sync
```

However, plugins configured by the traditional method (*Git*) are not installed during the first *Sync* as they are not versioned and generate a number of errors, but these do not affect the installation of the *luarocks* ones. To fix them you will need to close the editor, reopen it and re-run another `:Rocks sync` and you will have all the configuration plugins installed and configured.

The restart also provides for automatic installation of the LSPs used by *nvim-lspconfig*; their installation is displayed in the statusline; for the missing LSPs (used by *conform* and *nvim-lint*) an autocommand is set up to take care of their installation:

```txt
:MasonInstallAll
```

Close and reopen the editor to also load the configurations of plugins installed via *git* and you are ready to develop.
