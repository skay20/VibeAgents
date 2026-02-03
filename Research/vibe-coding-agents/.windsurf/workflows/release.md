# Workflow: RELEASE

Manage the release process including versioning, changelog, and deployment.

---

## Trigger

`/release [environment]`

## Steps

### 1. Pre-Release Checks

Verify:
- [ ] All tests pass
- [ ] Code review approved
- [ ] Changelog updated
- [ ] Documentation current
- [ ] No critical TODOs

### 2. Determine Version

Analyze commits since last tag:

```bash
git log $(git describe --tags --abbrev=0)..HEAD --oneline
```

- BREAKING CHANGE → MAJOR++
- feat: → MINOR++
- fix: → PATCH++

### 3. Update Changelog

Add to `CHANGELOG.md`:

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes to existing functionality

### Fixed
- Bug fixes

### Security
- Security improvements
```

### 4. Create Git Tag

```bash
git add CHANGELOG.md
git commit -m "chore(release): prepare vX.Y.Z"
git tag -a vX.Y.Z -m "Release vX.Y.Z"
git push origin vX.Y.Z
```

### 5. Deploy

```bash
# Staging
npm run deploy:staging

# Production
npm run deploy:production
```

### 6. Smoke Tests

Verify deployment:
- [ ] Homepage loads
- [ ] Login works
- [ ] Critical paths functional
- [ ] API health check passes

### 7. Monitor

Watch metrics:
- Error rate
- Response time
- CPU/Memory usage

### 8. Create Report

```yaml
release:
  version: "X.Y.Z"
  date: "YYYY-MM-DD"
  environment: staging|production
  
  changelog:
    added: []
    changed: []
    fixed: []
    
  deploy:
    status: success|failed
    duration: 0
    
  verification:
    smoke_tests: pass|fail
    health_checks: pass|fail
    
  monitoring:
    error_rate: 0%
    response_time: 0ms
```

### 9. Log the Run

Create `.ai/logs/runs/release-[version]-[timestamp].md`

## Output

### If successful:

```
✅ RELEASE Workflow Complete

🏷️ Version: vX.Y.Z
🚀 Environment: production
✅ Deploy: SUCCESS

📊 Smoke Tests: PASS
📈 Health Checks: PASS

📋 Changelog:
   - Added: X items
   - Changed: Y items
   - Fixed: Z items

📊 Monitoring:
   - Error Rate: X%
   - Response Time: Yms

✅ Release completed successfully!
```

### If issues:

```
⚠️ RELEASE Workflow - Issues Detected

🏷️ Version: vX.Y.Z
❌ Deploy: FAILED

🚨 Issues:
   - [description]

↩️ Rollback initiated: [yes/no]

Next: Fix issues and retry
```
