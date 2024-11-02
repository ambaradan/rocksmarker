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
The version can be downloaded from the [official Lua site](https://www.lua.org/download.html) with the command:

```bash
curl -O https://www.lua.org/ftp/lua-5.1.5.tar.gz
```

Once downloaded unpack it and place it inside:

```bash
tar xzf lua-5.1.5.tar.gz
cd lua-5.1.5
```

For its installation, the `INSTALL_TOP` variable is used to select the installation path, thus allowing installation in the user's *home* folder.To install, run the following commands:

```bash
make linux test
make install INSTALL_TOP=~/.local
```

The installation will copy the files to the following locations:

* **lua** **luac** -> `/home/<user>/.local/bin`
* **lua.h** **luaconf.h** **lualib.h** **lauxlib.h** **lua.hpp** -> `/home/<user>/.local/include`
* **liblua.a** -> `/home/<user>/.local/lib`

For its removal just delete the files listed above.

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

Once the installation is finished, it will be highlighted on the screen that the plugins that are installed with a are missing:

```txt
:Rocks sync
```

However, plugins configured by the traditional method (*Git*) are not installed during the first *Sync* as they are not versioned and generate a number of errors, but these do not affect the installation of the *luarocks* ones. To fix them you will need to close the editor, reopen it and re-run another `:Rocks sync` and you will have all the configuration plugins installed and configured.

The reboot also provides automatic installation of the LSPs used by *nvim-lspconfig*, their installation ending with *bashls* will be displayed in the statusline, for the missing LSPs (used by *conform* and *nvim-lint*) an autocommand has been set up to take care of their installation:

```txt
:MasonInstallAll
```

Close and reopen the editor to also load the configurations of plugins installed via *git* and you are ready to develop.
