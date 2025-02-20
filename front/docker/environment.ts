// The file contents for the current environment will overwrite these during build.
// The build system defaults to the dev environment which uses `environment.ts`, but if you do
// `ng build --env=prod` then `environment.prod.ts` will be used instead.
// The list of which env maps to which file can be found in `.angular-cli.json`.
export const environment = {
  name: 'production',
  production: true,
  version: '1.8.5',
  rollbar_key: '',
  date_format: 'DD MM YY HH:mm:ss',
  api: {
    client_id:     '',
    client_secret: '',
    host:          'https://backend.url',
    token_path:    '/oauth/v2/token'
  }
};
