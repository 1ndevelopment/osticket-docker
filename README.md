# osTicket Docker Setup

A complete Docker Compose setup for osTicket with MySQL database and phpMyAdmin for easy deployment and management.

## 🚀 Quick Start

1. **Clone or download** this repository
2. **Start the services**:
   ```bash
   docker-compose up -d
   ```
3. **Wait for initialization** (first startup may take 2-3 minutes)
4. **Access osTicket** at http://localhost:8080

## 📋 What's Included

- **osTicket**: Latest version of the open-source help desk system
- **MySQL 8.0**: Database backend with persistent storage
- **phpMyAdmin**: Web-based database administration tool (optional)
- **Persistent Storage**: All data survives container restarts

## 🔧 Services & Ports

| Service | URL | Purpose |
|---------|-----|---------|
| osTicket | http://localhost:8080 | Main help desk application |
| phpMyAdmin | http://localhost:8081 | Database management interface |

## 🔐 Default Credentials

### osTicket Admin Panel
- **URL**: http://localhost:8080/scp/
- **Username**: `admin`
- **Password**: `Admin123!`

### Database Access
- **Host**: `osticket-db`
- **Database**: `osticket`
- **Username**: `osticket`
- **Password**: `osticketpass123`

### phpMyAdmin
- **Username**: `root`
- **Password**: `rootpassword123`

## 📁 Directory Structure

```
osticket-docker/
├── docker-compose.yml
├── README.md
└── mysql-init/          # Optional: Custom SQL initialization scripts
```

## ⚙️ Configuration

### Environment Variables

Key configuration options in `docker-compose.yml`:

```yaml
# Database Configuration
MYSQL_HOST: osticket-db
MYSQL_DATABASE: osticket
MYSQL_USER: osticket
MYSQL_PASSWORD: osticketpass123

# Security
INSTALL_SECRET: your-secret-key-here-change-this

# Email Configuration (optional)
SMTP_HOST: smtp.gmail.com
SMTP_PORT: 587
SMTP_FROM: noreply@example.com
```

### Email Setup

To enable email notifications:

1. Update the SMTP settings in `docker-compose.yml`
2. Add your email credentials:
   ```yaml
   SMTP_USER: 'your-email@gmail.com'
   SMTP_PASS: 'your-app-password'
   ```
3. Restart the containers: `docker-compose restart osticket`

## 🛠️ Common Commands

### Start Services
```bash
docker-compose up -d
```

### Stop Services
```bash
docker-compose down
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f osticket
```

### Restart Services
```bash
docker-compose restart
```

### Update to Latest Version
```bash
docker-compose pull
docker-compose up -d
```

## 💾 Data Persistence

Data is stored in Docker volumes:

- `osticket_db_data`: MySQL database files
- `osticket_data`: osTicket application files
- `osticket_uploads`: File attachments and uploads

### Backup Data
```bash
# Database backup
docker-compose exec osticket-db mysqldump -u root -prootpassword123 osticket > backup.sql

# Volume backup
docker run --rm -v osticket_db_data:/data -v $(pwd):/backup alpine tar czf /backup/osticket_backup.tar.gz /data
```

### Restore Data
```bash
# Database restore
docker-compose exec -T osticket-db mysql -u root -prootpassword123 osticket < backup.sql
```

## 🔒 Security Considerations

### For Production Use:

1. **Change all default passwords**:
   - Database passwords
   - Admin password
   - INSTALL_SECRET

2. **Use environment files**:
   ```bash
   # Create .env file
   echo "MYSQL_ROOT_PASSWORD=your-secure-password" > .env
   ```

3. **Enable HTTPS**:
   - Use a reverse proxy (nginx, Traefik)
   - Configure SSL certificates

4. **Restrict access**:
   - Remove phpMyAdmin in production
   - Use firewall rules
   - Configure proper network security

5. **Regular updates**:
   ```bash
   docker-compose pull && docker-compose up -d
   ```

## 🐛 Troubleshooting

### osTicket won't start
```bash
# Check logs
docker-compose logs osticket

# Restart services
docker-compose restart
```

### Database connection issues
```bash
# Verify database is running
docker-compose ps

# Check database logs
docker-compose logs osticket-db

# Test database connection
docker-compose exec osticket-db mysql -u osticket -posticketpass123 -e "SELECT 1;"
```

### Permission issues
```bash
# Fix file permissions
docker-compose exec osticket chown -R www-data:www-data /var/www/html
```

### Reset admin password
```bash
# Connect to database
docker-compose exec osticket-db mysql -u root -prootpassword123 osticket

# Reset password (in MySQL prompt)
UPDATE ost_staff SET passwd = MD5('newpassword') WHERE username = 'admin';
```

## 📚 Additional Resources

- [osTicket Documentation](https://docs.osticket.com/)
- [osTicket GitHub Repository](https://github.com/osTicket/osTicket)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

This setup is provided as-is for educational and development purposes. osTicket is licensed under the GPL v2.