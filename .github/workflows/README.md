# GitHub Actions Workflows for Kai Web Docker Deployment

This directory contains GitHub Actions workflows for building and pushing the Kai web app Docker images to **GitHub Container Registry**.

## 📦 Available Workflows

### 1. `docker-build.yml` - Build and Push to GitHub Container Registry

**Purpose:** Build and push Docker image to GitHub Container Registry (ghcr.io)

**Triggers:**
- Push to `infra` branch
- Manual trigger via workflow_dispatch

**Features:**
- ✅ Multi-architecture (linux/amd64, linux/arm64)
- ✅ Docker Buildx with GHA caching
- ✅ Automatic multi-tagging (ref, SHA, latest)
- ✅ Uses GitHub Actions token for authentication

**Registry URL:** `ghcr.io/gitlogos/kai-web`

---

### 2. `push-gitlab.yml` - Push to GitHub Container Registry

**Purpose:** Dedicated workflow for pushing to GitHub Container Registry

**Triggers:**
- Push to `infra` branch
- Manual trigger via workflow_dispatch

**Features:**
- ✅ GitHub Container Registry integration (ghcr.io)
- ✅ Multi-architecture support
- ✅ Automatic version tags
- ✅ Uses GitHub Actions token

**Auto-Tagged Images:**
- `ghcr.io/gitlogos/kai-web:${{ github.ref_name }}`
- `ghcr.io/gitlogos/kai-web:${{ github.sha }}`
- `ghcr.io/gitlogos/kai-web:${{ github.event.repository.default_branch }}`
- `ghcr.io/gitlogos/kai-web:latest`

---

## 🔧 Authentication

### GitHub Container Registry (ghcr.io)

**No secrets required!** GitHub Actions automatically authenticates using:

```yaml
REGISTRY_USER: ${{ github.actor }}
REGISTRY_PASSWORD: ${{ secrets.GITHUB_TOKEN }}
```

**Benefits:**
- ✅ No extra configuration needed
- ✅ Automatic token generation
- ✅ Secure authentication
- ✅ No external credentials

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
2. Login to ghcr.io (automatic with GitHub token)
3. Build Docker image with Docker Buildx
4. Push to GitHub Container Registry
5. Tag with: branch name, git SHA, default branch, latest

### Step 3: Deploy to Portainer

```bash
# Pull latest image from GitHub Container Registry
docker pull ghcr.io/gitlogos/kai-web:latest

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
4. Enter version tag (optional, defaults to `latest`)
5. Click **Run workflow**

---

## 📊 Workflow Outputs

### Build Success

```
✅ Images built and pushed to ghcr.io:
   - ghcr.io/gitlogos/kai-web:infra
   - ghcr.io/gitlogos/kai-web:<commit-sha>
   - ghcr.io/gitlogos/kai-web:main
   - ghcr.io/gitlogos/kai-web:latest
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
# Verify GitHub Actions token
# Check ghcr.io status
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
  REGISTRY: 'ghcr.io'
```

---

## 🔒 Security Best Practices

1. **No external secrets needed** - Uses GitHub Actions token automatically
2. **Enable required reviewers** - Prevent unauthorized deployments
3. **Use image scanning** - Optional: add image vulnerability scanning
4. **Tag consistently** - Use semantic versioning
5. **Monitor workflow runs** - Alert on failures

---

## 📚 Additional Resources

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [GitHub Container Registry](https://docs.github.com/en/packages/ghcr/about-github-package-registry)
- [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [Docker Multi-Platform Builds](https://docs.docker.com/build/building/multi-platform/)

---

## ✅ Quick Reference

```bash
# View image in GitHub
ghcr.io/gitlogos/kai-web:latest

# Pull image locally
docker pull ghcr.io/gitlogos/kai-web:latest

# Deploy to Portainer
docker-compose up -d

# Check logs
docker-compose logs -f
```

---

**Last Updated:** 2026-05-19
