// refer to https://github.com/dalenguyen/firestore-backup-restore
// node js needed to execute file in terminal: 'node firestore_export_import.js'


const { initializeFirebaseApp } = require('firestore-export-import')
const { backups } = require('firestore-export-import')
const serviceAccount = require('./serviceAccountKey.json')
const fs = require('fs');
// If you want to pass settings for firestore, you can add to the options parameters
// const options = {
//     firestore: {
//         host: 'localhost:8080',
//         ssl: false,
//     },
// }

// Initiate Firebase App
// appName is optional, you can omit it.
const appName = '[DEFAULT]'
initializeFirebaseApp(serviceAccount, appName)
// backups().then((collections) => {console.log(JSON.stringify(collections))}).catch((err) => {console.log(err)})

backups().then((collections) => {
    const content = JSON.stringify(collections);
    fs.writeFile('backup.json', content, 'utf8', function (err) { if (err) { return console.log(err); } console.log('The file was saved!'); });
})

// the appName & options are OPTIONAL
// you can initalize the app without them
// initializeFirebaseApp(serviceAccount)

