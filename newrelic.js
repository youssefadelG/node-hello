'use strict';

exports.config = {
  app_name: ['node-hello'],
  license_key: process.env.NEW_RELIC_LICENSE_KEY,
  distributed_tracing: {
    enabled: true,
  },
  logging: {
    enabled: true,
    level: 'info',
  },
  application_logging: {
    enabled: true,
    forwarding: {
      enabled: true,
      max_samples_stored: 10000,
    },
    metrics: {
      enabled: true,
    },
    local_decorating: {
      enabled: true,
    },
  },
};
