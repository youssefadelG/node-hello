require('newrelic');

const http = require('http');
const logger = require('./logger');
const port = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  logger.info('Received request', {
    url: req.url,
    method: req.method,
    userAgent: req.headers['user-agent'],
    ip: req.connection.remoteAddress,
  });

  res.statusCode = 200;
  const msg = 'Hello Node!\n';
  res.end(msg);

  logger.info('Response sent successfully', {
    statusCode: res.statusCode,
    contentLength: msg.length,
  });
});

server.listen(port, () => {
  logger.info('Server started successfully', {
    port: port,
    environment: process.env.NODE_ENV || 'development',
    newRelicEnabled: !!process.env.NEW_RELIC_LICENSE_KEY,
  });
});
