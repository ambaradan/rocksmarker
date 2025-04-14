# Mkdocs-toolkit

## Description of the project

The **mkdocs-toolkit** project represents a comprehensive solution for managing technical documentation through the use of MkDocs, a powerful documentation generation tool. This design of this toolkit is to simplify the process of creating, managing and publishing documentation by offering several advanced and customizable features.

The core of the *mkdocs-toolkit* project is in its ability to integrate seamlessly with the Neovim development environment, offering a range of commands to simplify day-to-day operations. The toolkit also provides several features for managing Python virtual environments, enabling contributors to create, activate and manage isolated and reproducible development environments.

One of the most interesting features of the *mkdocs-toolkit* project is its ability to support multiple templates for documentation, which are the popular **Material** theme and the **Rockydocs** theme (custom *Material* theme of Rocky Linux documentation). This allows contributors to use the look and structure of their documentation according to their specific needs. In addition, the toolkit includes several documentation publishing features, allowing contributors to easily share their documentation with other team members or the community.

Browser preview is also provided. This feature allows contributors to preview technical documentation before making it available for publication. This ensures the documentation accuracy, completeness, and that it meets the required quality standards.

Preview view allows documentation authors to check the formatting, structure, and content of documentation, reducing the risk of errors and inconsistencies. With this feature, authors can check documentation at different stages of the creation process, reducing the time and effort required for review and correction.

## Description of the libraries

The functions of mkdocs-toolkit code are numerous.  A few main categories represent the division of these functions. One of the most important functions is the management of Python virtual environments, which allows contributors to create, activate and manage isolated, reproducible development environments. The **create**, **activate**, and **deactivate** functions in the `utils.lua` file make this possible. This allows for the creation, activation, and deactivation, of a new virtual environment.

Another important logic in the code is the MkDocs documentation management present in `main.lua`, which allows contributors to create, manage and publish technical documentation. The **M.material** and **M.rockydocs** functions allow creating new documentation projects with predefined themes, while the **M.serve** and **M.build** functions allow starting the development server and building documentation. In addition, the **M.stop_serve** function allows for stopping the development server.

In addition, the *mkdocs-toolkit* code includes functions for managing documentation and virtual environments, such as the **M.mkdocs_status** function, which allows for the viewing of the status of the current documentation and virtual environment, and the **M.status** function, which allows for the viewing of the status in the current Python virtual environment.

## Embedding of libraries

The line **require(“utils.mkdocs-toolkit.init”)** in the main `init.lua` configuration file loads the *init* module of the mkdocs-toolkit project. The init module is responsible for initializing the project and configuring the basic settings.

When calling the require function with the argument “*utils.mkdocs-toolkit.init*”, Neovim looks for the file *init.lua* within the project's `utils/mkdocs-toolkit` directory. If found, it loads it, making the functions and variables defined within the file available for use in the Neovim code.

The *init.lua* file of the *mkdocs-toolkit* project uses the require function to load several Lua modules. The first line of the file, *require(“utils.mkdocs-toolkit.main”)*, loads the project's **main** module, which contains the main toolkit logic.  
The main module is responsible for managing the MkDocs documentation and Python virtual environments. It provides many functions for creating, managing, and publishing technical documentation.

The second line of the file, *require(“utils.mkdocs-toolkit.utils”)*, loads the project's utils module, which contains useful functions for managing virtual environments and documentation. The utils module provides functions such as **get_python_path** for Python path management, and **get_preserved_paths** for managing the preservation of paths.

The third line of the file, *require(“utils.mkdocs-toolkit.mappings”)*, loads the project's mappings module, which contains the definition of commands and keyboard mappings for the toolkit such as the **MkdocsRockyDocsSetup** function for creating new documentation projects with the Rocky theme.

## Commands

The `mappings.lua` file provides several commands for Neovim to use the features of the *mkdocs-toolkit* project. Here are the commands provided:

- **MkdocsRockyDocsSetup**: Creates a new documentation project with the Rocky theme. You can use this to create a new documentation project with the settings used for Rocky Linux documentation.
- **MkdocsMaterialSetup**: Creates a new documentation project with the Material theme. You can use this to create a new documentation project with the default settings of the Material theme.
- **MkdocsStandardSetup**: Creates a new documentation project with the standard default settings. You can use this to create a new documentation project with basic settings on which to develop your own documentation.
- **MkdocsServe**: Starts the development server for documentation. You can use this to start the development server and view the documentation in the browser.
- **MkdocsStop**: Stops the development server for documentation. You can use this to stop the development server when it is no longer needed.
- **MkdocsBuild**: Builds the documentation. You can use this to build the documentation and create the HTML files for viewing in the browser.
- **MkdocsStatus**: Displays the status of MkDocs. You can use this to view the status of MkDocs, the status of the virtual environment, and the Python executable used, and check for errors or problems.

In addition, the code also provides mappings for managing Python virtual environments:

- **PyVenvCreate**: Creates a new Python virtual environment. You can use this to create a new Python virtual environment for the project.
- **PyVenvActivate**: Activates the Python virtual environment. You can use this to activate the Python virtual environment and use the libraries and tools installed within it.
- **PyVenvDeactivate**: Deactivates the Python virtual environment. You can use this to deactivate the Python virtual environment and return to the system environment.
- **PyVenvStatus**: Displays the status of the Python virtual environment. You can use this to view the status of the Python virtual environment and check for errors or problems.
- **PyVenvList**: Displays the list of available Python virtual environments. You can use this to display the list of available Python virtual environments.
- **PyVenvRemove**: Removes the Python virtual environment. You can use this to remove the Python virtual environment and create a new environment.

These commands used to manage documentation and Python virtual environments within Neovim allow you to use *mkdocs-toolkit* project features efficiently and quickly.

## Conclusions

In conclusion, the **mkdocs-toolkit** project represents a comprehensive and customizable solution for managing technical documentation and Python virtual environments within Neovim. The code provides many commands that allow the efficient, and quick,  use of the project's functionality, and it also offers customization options to adapt the theme to the user's specific needs.
