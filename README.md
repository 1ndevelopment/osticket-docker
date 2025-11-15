# osTicket Docker Setup

A production-ready Docker Compose configuration for osTicket with MySQL 8.0 and phpMyAdmin, designed for rapid deployment and simplified management.

## Features

- **osTicket**: Latest version of the open-source ticketing system
- **MySQL 8.0**: Reliable database backend with persistent storage
- **phpMyAdmin**: Optional web-based database management interface
- **Volume Persistence**: All data survives container restarts and updates
- **Simple Configuration**: Environment-based settings for easy customization

## Quick Start

### Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/1ndevelopment/osticket-docker.git
   cd osticket-docker
   ```

2. Build and launch the stack:
   ```bash
   ./build-run.sh
   ```

3. Wait for initialization (2-3 minutes on first run)

4. Access the application:
   - **osTicket**: http://localhost:8080
   - **phpMyAdmin**: http://localhost:8081

## Default Credentials

### osTicket Admin Panel
- **URL**: http://localhost:8080/scp/
- **Username**: `admin`
- **Password**: `Admin123!`

⚠️ **Change these credentials immediately after first login**

### Database
- **Host**: `osticket-db`
- **Database**: `osticket`
- **User**: `osticket`
- **Password**: `osticketpass123`

### phpMyAdmin
- **URL**: http://localhost:8081
- **Username**: `root`
- **Password**: `rootpassword123`

## Configuration

### Database Settings

Edit `docker-compose.yml` to customize database parameters:

```yaml
environment:
  MYSQL_HOST: osticket-db
  MYSQL_DATABASE: osticket
  MYSQL_USER: osticket
  MYSQL_PASSWORD: osticketpass123
```

### Email Notifications

To enable SMTP email support:

1. Update the osTicket service environment in `docker-compose.yml`:
   ```yaml
   SMTP_HOST: smtp.gmail.com
   SMTP_PORT: 587
   SMTP_FROM: noreply@example.com
   SMTP_USER: your-email@gmail.com
   SMTP_PASS: your-app-password
   ```

2. Restart the services:
   ```bash
   docker-compose restart osticket
   ```

### Security Configuration

Change the installation secret in `docker-compose.yml`:

```yaml
INSTALL_SECRET: your-unique-secret-key-change-this
```

## Management

### Service Control

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# Restart services
docker-compose restart

# Restart specific service
docker-compose restart osticket
```

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f osticket
docker-compose logs -f osticket-db
```

### Update Services

```bash
docker-compose pull
docker-compose up -d
```

## Data Persistence

Data is stored in named Docker volumes:

- `osticket_db_data` - MySQL database files
- `osticket_data` - osTicket application files
- `osticket_uploads` - User file attachments

### Backup

#### Database Backup
```bash
docker-compose exec osticket-db mysqldump -u root -prootpassword123 osticket > backup-$(date +%Y%m%d).sql
```

#### Full Volume Backup
```bash
docker run --rm \
  -v osticket_db_data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/osticket_volumes_$(date +%Y%m%d).tar.gz /data
```

### Restore

#### Database Restore
```bash
docker-compose exec -T osticket-db mysql -u root -prootpassword123 osticket < backup.sql
```

## Security Best Practices

### Essential Security Steps

1. **Change All Default Passwords**
   - Database root and user passwords
   - osTicket admin password
   - `INSTALL_SECRET` value

2. **Use Environment Files**
   ```bash
   # Create .env file for sensitive data
   cat > .env << EOF
   MYSQL_ROOT_PASSWORD=your-secure-password
   MYSQL_PASSWORD=another-secure-password
   INSTALL_SECRET=random-secret-key
   EOF
   
   # Update docker-compose.yml to reference .env variables
   ```

3. **Enable HTTPS**
   - Deploy behind a reverse proxy (nginx, Traefik, Caddy)
   - Configure SSL/TLS certificates (Let's Encrypt recommended)

4. **Production Hardening**
   - Remove phpMyAdmin service in production environments
   - Configure firewall rules to restrict port access
   - Use Docker secrets for sensitive data
   - Enable Docker's user namespace remapping

5. **Regular Maintenance**
   ```bash
   # Update containers regularly
   docker-compose pull && docker-compose up -d
   ```

## Troubleshooting

### Connection Issues

Check service status:
```bash
docker-compose ps
```

### Database Connection Failed

Verify database is running:
```bash
docker-compose logs osticket-db
```

Test database connectivity:
```bash
docker-compose exec osticket-db mysql -u osticket -posticketpass123 -e "SELECT 1;"
```

### File Permission Errors

Fix ownership:
```bash
docker-compose exec osticket chown -R www-data:www-data /var/www/html
```

### Reset Admin Password

1. Connect to the database:
   ```bash
   docker-compose exec osticket-db mysql -u root -prootpassword123 osticket
   ```

2. Run in MySQL prompt:
   ```sql
   UPDATE ost_staff SET passwd = MD5('newpassword') WHERE username = 'admin';
   ```

### View Container Logs

```bash
# All logs
docker-compose logs -f

# Specific service
docker-compose logs -f osticket
```

## Project Structure

```
osticket-docker/
├── docker-compose.yml    # Main configuration file
├── README.md            # This file
└── mysql-init/          # Optional: Custom SQL initialization scripts
```

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This Docker setup is provided as-is for educational and development purposes. osTicket itself is licensed under GPL v2.

## Support

For issues specific to this Docker setup, please open an issue on GitHub. For osTicket-specific questions, refer to the [official osTicket documentation](https://docs.osticket.com/).

---

**⚠️ Important**: This setup uses default credentials for demonstration purposes. Always change these values before deploying to production environments.
