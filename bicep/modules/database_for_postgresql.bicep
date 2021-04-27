param appName string
param environment string
param dbName string
param dbUser string
param dbPassword string

var DBforPostgreSQLName = '${appName}PostgreSQL${environment}'
var DBforPostgreSQLID = DBforPostgreSQL.id

resource DBforPostgreSQL 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: DBforPostgreSQLName
  location: resourceGroup().location
  sku: {
    name: 'GP_Gen5_2'
  }
  properties: {
    createMode: 'Default'
    version: '11'
    administratorLogin: dbUser
    administratorLoginPassword: dbPassword
    storageProfile: {
      storageMB: 102400
      backupRetentionDays: 7
      geoRedundantBackup: 'Enabled'
    }
  }
}

resource DBforPostgreSQLDB 'Microsoft.DBforPostgreSQL/servers/databases@2017-12-01' = {
  name: '${DBforPostgreSQL.name}/${dbName}'
  properties: {
    charset: 'UTF8'
    collation: 'English_United States.1252'
  }
}

resource DBforPostgreSQLName_tcp_keepalives_idle 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = {
  name: '${DBforPostgreSQL.name}/tcp_keepalives_idle'
  properties: {
    value: '300'
  }
}

resource DBforPostgreSQLName_tcp_keepalives_interval 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = {
  name: '${DBforPostgreSQL.name}/tcp_keepalives_interval'
  properties: {
    value: '20'
  }
}

resource DBforPostgreSQLName_tcp_keepalives_count 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = {
  name: '${DBforPostgreSQL.name}/tcp_keepalives_count'
  properties: {
    value: '20'
  }
}

output DBforPostgreSQLID string = DBforPostgreSQLID
