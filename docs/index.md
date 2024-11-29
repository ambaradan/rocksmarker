---
title: Rocksmarker
author: Franco Colussi
contributors: Steve Spencer
tags:
    - neovim
    - editor
    - markdown
---

# Rocksmarker - Neovim Markdown IDE

## Introduction

The project aims to build a configuration of *Neovim* optimized for writing documentation in Markdown format with a *standard installation of Neovim* as a base. This project uses a young, but very promising project, *rocks.nvim*, for plugin management. The idea arose from the curiosity to develop a Neovim configuration that is not managed by *lazy.nvim*, the "de facto" manager of all the major configurations currently available (NvChad, LunarVim, LazyVim, and others).

### Reason for change of manager

*Lazy.nvim* is a good tool for managing Neovim plugins but introduces some limitations. To work properly, it requires the complete disabling of Neovim's built-in plugins making for example the integration of localization features (such as *spell*) very complicated. In contrast, *rocks.nvim* is much less intrusive and does not require any special settings of the basic Neovim configuration.

*Rocks.nvim* uses a centralized file for plugin operations (install, remove, update), separating these operations from the configuration logic of the plugins themselves, and making their management easier. Also *lazy.nvim* includes a mechanism to exclude the plugin from the configuration, but it must be manually set in the corresponding configuration file, making management more complicated.

## Main components

* **Neovim** - modern terminal text editor born from a fork of Vim that, while sharing its basic features, expands its extensibility, allowing you to further customize Neovim to suit your needs (plugins, appearance, and so on.)
* **rocks.nvim** - plugin manager for Neovim that aims to revolutionize Neovim plugin management by simplifying the way users and developers manage plugins and dependencies, integrating directly with luarocks

**Neovim** is a project that needs no introduction. It provides a stable, customizable high-performance editor, usable for the development of virtually any programming language. The language used to build it (*lua*) makes it portable to multiple architectures and extremely fast. The use of *lua* allows injecting blocks of code to change its properties such as appearance, functionality, and so on.

**Rocks.nvim** is a young but growing project. Its use has proved stable. Main features include:

* Minimal and non-intrusive user interface
* Automatic handling of dependencies and build scripts
* Completion of commands
* Plugins provided in binary version, thus no need for compilation, taken from luarocks.org
* Modularity

> [!NOTE]
> This last aspect is very interesting. It is possible, starting from the main plugin *rocks.nvim*, to extend its functionality through additional plugins that introduce new configuration and installation possibilities. Modularity also makes it possible to exclude unused code from the configuration that could create problems or conflicts.

## Appearance and UI

The editor provides a single interface based on the [bamboo.nvim](https://github.com/ribru17/bamboo.nvim) theme on dark green hues, written in Lua with Tree-sitter syntax highlighting and LSP semantic highlighting. The style was also applied to the additional plugins to conform to the interface.  
The creation of a set of colors in `lua/plugins/bamboo.lua` facilitates marker recognition without being intrusive.

## Additional components

The integration includes various plugins for workflow management. The workflow mainly consists of writing or editing Markdown documents, so there are tools for managing files, searching and replacing words or phrases, managing files in a *Git* repository, and other utilities.

## Markdown set

Included in the configuration for this project are all plugins available in Neovim for manipulating and displaying markdown documents. The plugins were thoroughly tested to work with *rocks.nvim*, and if not yet available in *luarocks* version, installation occurred with the additional utility, *rocks-git.nvim*.  
An autocommand, triggered by the file type, was also created that sets the buffer characteristics for optimized writing of markdown code.

## Acknowledgements

A big thank you goes to the developers of NvChad for the excellent code produced that served as a study and inspiration for writing this configuration. Thanks also to the developers of *rocks.nvim*, who brought a breath of fresh air to the management of Neovim plugins, and to all the developers of the plugins used.

## References

[Neovim](https://neovim.io/) - built for users who want the best parts of Vim, and more  
[Rocks.nvim](https://github.com/nvim-neorocks/rocks.nvim) - a modern approach to Neovim plugin management  
[luarocks.org](https://luarocks.org/) - allows the creation and installation of Lua modules as stand-alone packages  
[NvChad](https://nvchad.com/) - excellent editor for code development, mainly *Lua* but easily extensible
