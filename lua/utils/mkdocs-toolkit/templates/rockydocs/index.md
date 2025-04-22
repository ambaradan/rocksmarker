# Introduction to rocksmarker for Rocky Linux documentation

`rocksmarker` is a Neovim configuration created for the sole purpose of giving Rocky Linux documentation writers, a turnkey documentation development system. The project has many individual elements by default, and some that are optional but highly recommended. Here is a brief listing:

* `rocks.nvim` (default) is the underlying plugin engine for `rocksmarker`. It shifts the responsibility of specifying dependencies and build steps from users to plugin authors. This helps to reduce errors on updates, allowing users to concentrate on writing or editing documentation, rather than on whether a plugin will break their configuration.
* Assorted language server plugins (LSP)(default) which cover the Markdown language, spelling, `html`, `bash`, `yaml`, and various formatting. While `bash`, `html`, and `yaml` have little to do with Markdown code, they provide users the flexibility to use the editor syntactically for other purposes. The `yaml` LSP, for example, provides a means for editing the `rocksmarker` configuration files.
* `vale` (optional, but installed by default) is an LSP for linting prose. This LSP allows writers and editors to check their work against dictionaries for proper word usage, and encourages them to avoid passive-voice, and words or phrases that might be offensive to some. This LSP requires some setup to be fully active (`.vale.ini`, the installation of dictionaries), but is highly recommended.
* `mkdocs-toolkit` (optional) A python virtual environment generator that creates a web interface similar to <docs.rockylinux.org> and updates almost in real time as you save content. This is a great way to review how your documentation will actually look when merged into the Rocky Linux project.

If fully implemented, these elements give the user an editor that helps them to write documentation with minimal errors, and allows for the quick viewing of their document in a web interface.
