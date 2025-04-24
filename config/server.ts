export default ({ env }) => ({
  host: env('HOST', '0.0.0.0'),
  port: env.int('PORT', 1337),
  app: {
    keys: env.array('APP_KEYS', ['someKey1', 'someKey2']),
  },
  webhooks: {
    populateRelations: env.bool('WEBHOOKS_POPULATE_RELATIONS', false),
  },
  admin: {
    serveAdminPanel: true,
    auth: {
      secret: env('ADMIN_JWT_SECRET', 'supersecret'),
    },
  },
  // 👇 This allows any domain including ALB DNS
  allowedHosts: ['*'],
});
