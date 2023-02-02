const child = require('child_process');
const crypto = require('crypto');
const path = require('path');
const fs = require('fs');
const os = require('os');

exports.handler = async (event) => {
    return process(event);
};

function process(event) {
    // Retrieve request body from the incoming request event, and if aws decided to base64 encode it, decode it.
    let body = (event.isBase64Encoded ? Buffer.from(event.body, 'base64').toString('utf8') : event.body);
    
    // Generate a random filename in /tmp/ to write the pdf to
    const tmpfile = "/tmp/" + crypto.randomBytes(6).readUIntLE(0,6).toString(36);

    // Execute wkhtmltopdf passing the html via stdin, and writing the pdf output to the random file in /tmp
    // Set quiet, low-quality, grayscale, portrait, and letter.
    child.execSync(`wkhtmltopdf -q -l -g -O Portrait -s Letter - ${tmpfile}`, { encoding: 'utf8', input: body }); 

    // Read the pdf file back into memory, as a base64 encoded string
    body = fs.readFileSync(tmpfile).toString('base64');
    
    // Delete the pdf file from /tmp
    fs.unlinkSync(tmpfile);
    
    // Return an object representing the response for aws to return to the caller.
    // Note: aws lambda can't return non-text responses, nor stream data back to the caller :(
    return { statusCode: 200, headers: { 'Content-Type': 'text/plain' }, body };
}
