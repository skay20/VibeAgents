# Runbook

> Guía de operaciones para el proyecto

---

## 1. Getting Started

### 1.1 Prerequisites

- Node.js >= 18
- npm >= 9
- Git

### 1.2 Installation

```bash
# Clone repository
git clone <repo-url>
cd <project-name>

# Install dependencies
npm install

# Copy environment variables
cp .env.example .env.local

# Start development
npm run dev
```

---

## 2. Development

### 2.1 Common Commands

```bash
# Development server
npm run dev

# Build
npm run build

# Tests
npm run test
npm run test:watch
npm run test:coverage

# Lint
npm run lint
npm run lint:fix

# Type check
npm run typecheck
```

### 2.2 Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `DATABASE_URL` | Database connection string | Yes |
| `API_KEY` | External API key | Yes |
| `DEBUG` | Enable debug logging | No |

---

## 3. Deployment

### 3.1 Staging

```bash
# Deploy to staging
npm run deploy:staging

# Verify
npm run verify:staging
```

### 3.2 Production

```bash
# Deploy to production
npm run deploy:production

# Verify
npm run verify:production
```

---

## 4. Troubleshooting

### 4.1 Common Issues

#### Issue: Build fails

**Symptoms**: 
```
Error: Build failed
```

**Solution**:
1. Check TypeScript errors: `npm run typecheck`
2. Check lint errors: `npm run lint`
3. Clear cache: `rm -rf node_modules && npm install`

#### Issue: Tests fail

**Symptoms**:
```
Test suite failed
```

**Solution**:
1. Run tests with verbose: `npm run test -- --verbose`
2. Check for environment issues
3. Update snapshots if needed: `npm run test -- -u`

### 4.2 Debug Mode

```bash
# Enable debug logging
DEBUG=* npm run dev

# Debug specific module
DEBUG=app:* npm run dev
```

---

## 5. Monitoring

### 5.1 Health Checks

```bash
# API health
curl https://api.example.com/health

# Expected response
{"status":"ok","timestamp":"2024-01-15T10:00:00Z"}
```

### 5.2 Logs

```bash
# View logs
npm run logs

# View specific service
npm run logs:api
```

### 5.3 Metrics

| Metric | Target | Alert Threshold |
|--------|--------|-----------------|
| Response Time | < 200ms | > 500ms |
| Error Rate | < 1% | > 5% |
| CPU Usage | < 70% | > 85% |
| Memory Usage | < 80% | > 90% |

---

## 6. Incident Response

### 6.1 Severity Levels

| Level | Description | Response Time |
|-------|-------------|---------------|
| P1 | Service down | 15 minutes |
| P2 | Major feature broken | 1 hour |
| P3 | Minor issue | 4 hours |
| P4 | Cosmetic | 24 hours |

### 6.2 Escalation

1. **P1/P2**: Page on-call engineer immediately
2. **P3**: Create ticket, assign to team
3. **P4**: Add to backlog

### 6.3 Rollback Procedure

```bash
# Identify last known good version
LAST_GOOD=$(git tag --sort=-version:refname | head -2 | tail -1)

# Rollback
npm run deploy:production -- --version=$LAST_GOOD

# Verify
npm run verify:production
```

---

## 7. Maintenance

### 7.1 Regular Tasks

| Task | Frequency | Owner |
|------|-----------|-------|
| Dependency updates | Weekly | DevOps |
| Security patches | As needed | Security |
| Database backup | Daily | DevOps |
| Log rotation | Daily | DevOps |

### 7.2 Database

```bash
# Run migrations
npm run db:migrate

# Seed database
npm run db:seed

# Backup
npm run db:backup

# Restore
npm run db:restore <backup-file>
```

---

## 8. Contacts

| Role | Name | Contact |
|------|------|---------|
| Tech Lead | | |
| DevOps | | |
| On-Call | | |

---

**Last Updated**: [DATE]
**Version**: 1.0.0
