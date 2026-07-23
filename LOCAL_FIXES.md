# Local Repository Fix Summary

This file documents the local fixes applied to make the cloned repository build and run correctly with Docker on macOS / Apple Silicon.

## Summary of changes

### `docker-compose.yml`
- Ensured the backend startup command cleans up stale Rails PID files before launching the server.
- Changed backend startup to run migrations and seed data before starting the Rails server.
- Added a frontend startup command that installs dependencies before running Vite.

### `backend/Dockerfile`
- Added `libyaml-dev` and `pkg-config` to support native gem compilation for YAML-related dependencies.
- Kept build steps focused on a clean Rails image with bundle install and Bootsnap precompile.

### `backend/bin/docker-entrypoint`
- Added explicit removal of `tmp/pids/server.pid` when the Rails server is invoked.
- Made the entrypoint run `rails db:prepare` as part of container startup.

### `frontend/package.json`
- Added `@rollup/rollup-linux-arm64-musl` to support Vite/Rollup on Apple Silicon / Linux ARM.
- This dependency resolves missing Rollup plugin errors during frontend container startup.

### `.gitignore`
- Added `/backend/vendor/bundle` to prevent host-specific installed gems from being committed.
- This keeps the repository clean and avoids image-specific Bundler artifacts being tracked.

## Why these fixes were needed

### Backend runtime issues
- The locally mounted backend source directory (`./backend:/rails`) hides the gems installed in the image, so container startup must rely on the container’s installed bundle and correct entrypoint behavior.
- A stale Puma/Rails server PID at `tmp/pids/server.pid` can prevent Rails from starting again after a previous shutdown.
- MySQL gem installation for Ruby requires YAML native headers, which are provided by `libyaml-dev` and `pkg-config` in Debian-based images.

### Frontend startup issues
- On Apple Silicon / Linux ARM, Vite/Rollup may require a platform-specific native package for bundling.
- Installing dependencies inside the container before `npm run dev` ensures the mounted frontend source and `node_modules` volume are populated correctly.

## Recommended local startup

1. Build and start containers:

```bash
docker compose up --build
```

2. Access the app:
- Frontend: `http://localhost:5173`
- Backend API: `http://localhost:3000`

## Notes

- If database setup fails, use the backend container directly to inspect and retry migration/seed commands.
- Because this is a locally cloned repository, these fixes focus on reproducible container startup rather than changing app business logic.
