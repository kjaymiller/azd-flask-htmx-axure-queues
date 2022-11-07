# Flask + Azure Storage Queues (Azure Web Apps)

This is a sample project that shows how to use [Azure Storage Queues](https://azure.microsoft.com/en-us/products/storage/queues/#overview) with [Flask](https://flask.palletsprojects.com/en/2.2.x/).

## Build

### via Azure Developer CLI:

[Azure Developer CLI](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/overview) (or AZD) is a command line tool that allows you to create, manage, and deploy Azure resources from the command line. It is a cross-platform tool that runs on Windows, macOS, and Linux.

If you have the Azure Developer CLI installed, you can build the project by running the following command while in this project's directory: `azd up`.

### Building Manually

- Create Azure Resource Group
- Create Azure Storage
- Create Azure Web App

Save Azure Storage connection string as an environment variable in Azure Web App Setting.

Create the name of the queue you want to use as an environment variable in Azure Web App Setting.

