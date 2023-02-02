const fs = require('fs');

/**
 * Tests the pdf lambda function.
 * 
 * Invokes the handler with an event exactly as AWS would invoke it to process an incoming request.
 * Verifies it executes and returns 200 OK with a base64 encoded pdf response body.
 * 
 * Note: tests require wkhtmltopdf to be installed.
 */

function testHandler(encoded) {
    const requestBody = fs.readFileSync('../fixtures/request_body.txt', { encoding: (encoded ? 'base64' : 'utf8') });
    const event = { isBase64Encoded: encoded, body: requestBody };
    const handler = require('../pdf/index');

    return handler.handler(event).then(response => {
        if (!(response.hasOwnProperty('statusCode') && response.statusCode == 200)) {
            throw 'Expected response to contain statusCode 200';
        }
        if (!(response.hasOwnProperty('headers') && response.headers.hasOwnProperty('Content-Type') && response.headers['Content-Type'] == 'text/plain')) {
            throw 'Expected response to contain text/plain Content-Type headers';
        }
        if (!(response.hasOwnProperty('body') && response.body.startsWith('JVBERi0xLjQKMSAwIG9i') && response.body.endsWith('Zgo0MTI5NgolJUVPRgo='))) {
            throw 'Expected response body to contain pdf';
        }
        console.log('Pass!');
    });
}

Promise.resolve()
    .then(() => testHandler(false))
    .then(() => testHandler(true))
    .catch(err => console.log('Fail!:', err));


