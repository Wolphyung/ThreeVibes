const swaggerJsdoc = require('swagger-jsdoc');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'ThreeVibes API',
      version: '1.0.0',
      description: 'API documentation for the ThreeVibes platform',
    },
    servers: [
      {
        url: '/api',
        description: 'API base path',
      },
    ],
  },
  apis: [
    './src/features/*/presentation/*.docs.js',
  ],
};

const swaggerSpec = swaggerJsdoc(options);

module.exports = swaggerSpec;
