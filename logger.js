const winston = require('winston');
const newrelicFormatter = require('@newrelic/winston-enricher')(winston);

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp({
      format: 'YYYY-MM-DD HH:mm:ss',
    }),
    winston.format.errors({ stack: true }),
    winston.format.json(),
    newrelicFormatter(),
  ),
  defaultMeta: { service: 'node-hello' },
  transports: [
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.simple(),
      ),
    }),

    new winston.transports.File({
      filename: 'app.log',
      format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json(),
      ),
    }),
  ],
});

logger.stream = {
  write: function (message) {
    logger.info(message.trim());
  },
};

module.exports = logger;
