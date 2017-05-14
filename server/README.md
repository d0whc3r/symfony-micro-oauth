# Security module (rest + oauth + user)

Symfony module with friendsofsymfony/rest-bundle, friendsofsymfony/oauth-server-bundle, friendsofsymfony/user-bundle

## Docker

##### Environment variables are defined in `docker/example.env` and `docker/dev.env`

```bash
git clone https://github.com/d0whc3r/symfony-micro-oauth.git
cd symfony-micro-oauth/docker
./start.sh dev --init
```

> $DOCKER_API should be defined in /etc/hosts (in this example: security.api)

```bash
curl -X POST \
  http://security.api:4444/oauth/v2/token \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/x-www-form-urlencoded' \
  -d 'grant_type=password&client_id=1_developmentClientId&client_secret=developmentSecretId&username=admin_dev&password=admin_password_dev'
```

RESPONSE:

```json
{
  "access_token": "NzliNDg1M2FmNGU4ZDM0MTBhZmRhMjQ5NGI0Y2U2NDkxOWE4MGE2OTA4ZTc0MjU3ZDAwN2U3N2QzZjQ3ZWNkNw",
  "expires_in": 99600,
  "token_type": "bearer",
  "scope": null,
  "refresh_token": "NjcxYzExNTE4MzgzZjk4MjY5ZDE1YjI4NGE4YzgzMzExNjU4YmU1MGFkNzdhNGQ5OWIxOTY5YzlkNjQxNGUzNQ"
}
```

Then you could:

```bash
curl -X POST \
  http://security.api:4444/api/act \
  -H 'accept: application/json' \
  -H 'authorization: Bearer NzliNDg1M2FmNGU4ZDM0MTBhZmRhMjQ5NGI0Y2U2NDkxOWE4MGE2OTA4ZTc0MjU3ZDAwN2U3N2QzZjQ3ZWNkNw' \
  -H 'content-type: application/json' \
  -d '{	"action": "https://jsonplaceholder.typicode.com/posts" }'
```

Or simply use as auth validator

```bash
curl -X GET \
  http://security.api:4444/api/user \
  -H 'accept: application/json' \
  -H 'authorization: Bearer NzliNDg1M2FmNGU4ZDM0MTBhZmRhMjQ5NGI0Y2U2NDkxOWE4MGE2OTA4ZTc0MjU3ZDAwN2U3N2QzZjQ3ZWNkNw'
```

RESPONSE:

```json
{
  "id": 1,
  "username": "admin_dev",
  "username_canonical": "admin_dev",
  "email": "some@email.com",
  "enabled": true,
  "last_login": null,
  "roles": [
    "ROLE_SUPER_ADMIN"
  ],
  "realname": null
}
```
