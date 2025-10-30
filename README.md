## osTicket on Docker

Production-ready Docker Compose stack for osTicket with MySQL and phpMyAdmin.

### Stack
- **osTicket app**: Apache + PHP 8.2, built from source via the included `Dockerfile`
- **MySQL 8.0**: Persistent database with healthcheck
- **phpMyAdmin**: Web UI for DB administration

### Requirements
- Docker
- Docker Compose v2

### Quick Start
1. Build the osTicket image (recommended for this repo):
   ```bash
   docker build -t osticket-app:latest ./osticket-docker/
   ```
   - Or change the compose service to `build: osticket-docker:latest`.

2. Launch:
   ```bash
   docker compose -f ./osticket-docker/docker-compose.yml up -d
   ```

3. Open:
   - osTicket: `http://localhost:8080`
   - phpMyAdmin: `http://localhost:8081` (Host: `osticket-mysql`, User: `root`, Password: `rootpassword`)

4. Complete the osTicket installer:
   - DB Host: `osticket-mysql`
   - DB Name: `osticket`
   - DB User: `osticket`
   - DB Password: `osticketpass123`
   - Set a strong admin password and ensure `INSTALL_SECRET` is a strong, stable value.

### Ports
- `8080 -> 80` osTicket (Apache/PHP)
- `8081 -> 80` phpMyAdmin

### Data Persistence
- MySQL data is stored in the named volume `osticket-mysql-data`.

### Configuration (docker-compose.yml)
- MySQL (`osticket-mysql`)
  - `MYSQL_ROOT_PASSWORD`: `rootpassword`
  - `MYSQL_DATABASE`: `osticket`
  - `MYSQL_USER`: `osticket`
  - `MYSQL_PASSWORD`: `osticketpass123`
- osTicket (`osticket-app`)
  - `MYSQL_HOST`: `osticket-mysql`
  - `MYSQL_PORT`: `3306`
  - `MYSQL_USER`: `osticket`
  - `MYSQL_PASSWORD`: `osticketpass123`
  - `MYSQL_DATABASE`: `osticket`
  - `INSTALL_SECRET`: set a strong random value
  - `PUID`: `1000`
  - `PGID`: `1000`
  - `TZ`: `UTC`
- phpMyAdmin (`osticket-phpmyadmin`)
  - `PMA_HOST`: `osticket-mysql`
  - `MYSQL_ROOT_PASSWORD`: must match MySQL root password

Change all default passwords and secrets before any non-local deployment.

### Build Details (Dockerfile)
- Base: `php:8.2-apache`
- Installs PHP extensions: `gd`, `mysqli`, `intl`, `zip`, `xml`, `mbstring`, `bcmath`
- Clones `https://github.com/osTicket/osTicket` into `/var/www/html`
- Runs `php manage.php deploy --setup /var/www/html/`
- Enables Apache `mod_rewrite`
- Exposes port `80`

If using Compose to build, edit the osTicket service:
```yaml
# in ./osticket-docker/docker-compose.yml
# replace:
#   image: docker.io/library/osticket-app:latest
# with:
#   build: osticket-docker:latest
```

### Operations
- Logs:
  ```bash
  docker compose -f ./osticket-docker/docker-compose.yml logs -f
  ```
- Restart:
  ```bash
  docker compose -f ./osticket-docker/docker-compose.yml restart
  ```
- Stop/Remove:
  ```bash
  docker compose -f ./osticket-docker/docker-compose.yml down
  ```
- Remove DB data (irreversible):
  ```bash
  docker volume rm osticket-mysql-data
  ```

### Troubleshooting
- Can’t connect to DB:
  - Wait for MySQL healthcheck; verify creds match across services.
- Installer loops/fails:
  - Ensure `INSTALL_SECRET` is set and unchanged across restarts.
- phpMyAdmin login fails:
  - Use host `osticket-mysql`; confirm root/user passwords.

### Security
- Replace all default passwords and `INSTALL_SECRET`.
- Limit exposure of phpMyAdmin; disable when not needed.
- Consider backups for `osticket-mysql-data` and config exports.

### License
This configuration is provided as-is. osTicket is licensed by its upstream project.