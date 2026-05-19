# GitHub Actions Workflows for Kai Web Docker Deployment

This directory contains GitHub Actions workflows for building and pushing the Kai web app Docker images.

## 📦 Available Workflows

### 1. `docker-build.yml` - Build and Push to Docker Registry

**Purpose:** Build and push Docker image to a configured registry (GitLab, Docker Hub, Azure, etc.)

**Triggers:**
- Push to `infra` branch
- Manual trigger via workflow_dispatch

**Features:**
- ✅ Multi-architecture (linux/amd64, linux/arm64)
- ✅ Docker Buildx with GHA caching
- ✅ Custom registry configuration
- ✅ Automatic tagging (ref, sha, latest)

**Configuration:**
```yaml
env:
  IMAGE_NAME: 'gitlogos/kai-web'
  REGISTRY: 'gitlab.io'
  REGISTRY_USER: '${{ secrets.REGISTRY_USER }}'
  REGISTRY_PASSWORD: '${{ secrets.REGISTRY_PASSWORD }}'
```

**Registry URL:** `{{ secrets.REGISTRY_USER }}@{{ secrets.REGISTRY_PASSWORD }}@{{ secrets.REGISTRY }}`

---

### 2. `push-gitlab.yml` - Push to GitLab Registry

**Purpose:** Dedicated workflow for pushing to GitLab Container Registry

**Triggers:**
- Push to `infra` branch
- Manual trigger via workflow_dispatch

**Features:**
- ✅ GitLab Registry integration
- ✅ Multi-architecture support
- ✅ Automatic version tags
- ✅ Detailed logging

**Auto-Tagged Images:**
- `${{ secrets.REGISTRY_USER }}@${{ secrets.REGISTRY_PASSWORD }}@gitlab.com/${{ env.IMAGE_NAME }}:${{ github.ref_name }}`
- `${{ secrets.REGISTRY_USER }}@${{ secrets.REGISTRY_PASSWORD }}@gitlab.com/${{ env.IMAGE_NAME }}:${{ github.sha }}`
- `${{ secrets.REGISTRY_USER }}@${{ secrets.REGISTRY_PASSWORD }}@gitlab.com/${{ env.IMAGE_NAME }}:${{ github.event.repository.default_branch }}`
- `${{ secrets.REGISTRY_USER }}@${{ secrets.REGISTRY_PASSWORD }}@gitlab.com/${{ env.IMAGE_NAME }}:latest`

---

## 🔧 Setting Up Secrets

### Required GitHub Secrets

Create these secrets in your GitHub repository settings:

```bash
# GitHub Settings → Secrets and variables → Actions → New secret

# 1. REGISTRY_USER
# Your registry username (e.g., gitlab.com, docker.io, etc.)
# Example: gitlab-ci-runner

# 2. REGISTRY_PASSWORD
# Your registry password or token
# Example: YOUR_TOKEN_FROM_REGISTRY

# 3. REGISTRY_URL (optional)
# Custom registry URL (if not gitlab.com)
# Example: https://docker.io
```

### Registry Login

**GitLab Registry:**
```bash
# Generate personal access token
gitlab.com → Settings → Access Tokens → New token
# Select: "read_registry" and "write_registry" permissions
```

**Docker Hub:**
```bash
# Docker Hub credentials
docker.io → Settings → Access Tokens
```

---

## 🚀 Deployment Workflow

### Step 1: Push Code to `infra` Branch

```bash
git checkout infra
git commit -m "Add Dockerfile and deployment config"
git push origin infra
```

### Step 2: GitHub Actions Builds Automatically

GitHub Actions will:
1. Check out code
2. Build Docker image with Docker Buildx
3. Push to configured registry
4. Tag with: branch name, git SHA, default branch, latest

### Step 3: Deploy to Portainer

```bash
# Pull latest image
docker pull gitlab.com/gitlogos/kai-web:latest

# Deploy using docker-compose
docker-compose up -d

# Check status
docker-compose ps
```

---

## 🎯 Manual Trigger

You can manually trigger the workflow:

1. Go to **Actions** tab in GitHub
2. Select `Build and Push Kai Web Docker Image`
3. Click **Run workflow**
4. Enter tag name (optional, defaults to `latest`)
5. Click **Run workflow**

---

## 📊 Workflow Outputs

### Build Success

```
✅ Images built and pushed:
   - gitlab.com/gitlogos/kai-web:infra
   - gitlab.com/gitlogos/kai-web:<commit-sha>
   - gitlab.com/gitlogos/kai-web:main
   - gitlab.com/gitlogos/kai-web:latest
```

### Build Failure

```
❌ Build failed with error:
   - [Error] Image build failed
   - [Error] Push failed
```

### Troubleshooting

**Issue: Build fails**
```bash
# Check logs
# View workflow run logs in GitHub Actions tab
```

**Issue: Push fails**
```bash
# Verify registry credentials
# Check registry status
# Verify image digest matches
```

---

## 🔄 Multi-Architecture Support

The workflows build images for:
- **linux/amd64** - x86_64 (most common)
- **linux/arm64** - ARM 64-bit (modern ARM processors)

**Benefits:**
- ✅ Works on any architecture
- ✅ OCI image format compatibility
- ✅ Automatic multi-arch manifests
- ✅ Containerd compatibility

---

## 📝 Environment Variables

Customize workflow behavior:

```yaml
env:
  IMAGE_NAME: 'gitlogos/kai-web'
  REGISTRY: 'gitlab.com'
```

---

## 🔒 Security Best Practices

1. **Never commit secrets** - Use GitHub Secrets
2. **Enable required reviewers** - Prevent unauthorized deployments
3. **Use image scanning** - Optional: add image vulnerability scanning
4. **Tag consistently** - Use semantic versioning
5. **Monitor workflow runs** - Alert on failures

---

## 📚 Additional Resources

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [Docker Multi-Platform Builds](https://docs.docker.com/build/building/multi-platform/)
- [GitLab Container Registry](https://docs.gitlab.com/ee/user/packages/container_image/)

---

## 🤝 Contributing

When adding new workflows:
1. Follow existing workflow structure
2. Use consistent secret naming
3. Add comprehensive documentation
4. Include error handling
5. Test on staging environment first

---

**Last Updated:** 2026-05-19
