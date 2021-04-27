# Azure Bicep Template - Web Server Sample

Template for building infrastructure for a web server.

## Login Azure and create resource group

```bash
$ az login
$ az group create --name your_resource_group --location 'Japan East'
$ az configure --defaults group=your_resource_group
```

## Deploy by Bicep

```bash
$ cd bicep
$ az deployment group create --template-file main.bicep --parameters main.parameters.json
```

## Compile and Decompile

```
# Compile
$ az bicep build  --file bicep/main.bicep

# Decompile
$ az bicep decompile --file arm/main.json
```