# helm-charts
Centralized Helm Chart Registry for the ShopHub platform. Contains package definitions for the core platform, dynamically provisioned user stores, and the custom Kubernetes operator. Built using Trunk Based Development, SemVer, and Conventional Commits.

Charts are published to GitHub Container Registry automatically when changes are pushed to `main`:

- `oci://ghcr.io/devops-siit-master/charts/shophub`
- `oci://ghcr.io/devops-siit-master/charts/shophub-discord`
- `oci://ghcr.io/devops-siit-master/charts/shop-operator`
