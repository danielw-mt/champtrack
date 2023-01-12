const { initializeFirebaseApp, restore } = require('firestore-export-import')
const serviceAccount = require('./liveServiceAccountKey.json')

// Import options
const options = {
    autoParseDates: true, // use this one in stead of dates: [...]
    geos: ['location', 'locations'],
    refs: ['refKey'],
};

// Initiate Firebase App
// appName is optional, you can omit it.
databaseURL = 'https://handball-performance-tracker.firebaseio.com'

const appName = '[DEFAULT]'
initializeFirebaseApp(serviceAccount, appName)

// Start importing your data
// The array of date, location and reference fields are optional
restore('backup.json', {})