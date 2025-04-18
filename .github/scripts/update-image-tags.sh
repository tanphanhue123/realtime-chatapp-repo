#!/bin/bash
DIRECTORIES=("database" "application" "reverb" "scheduler" "worker")
TAG_VERSION=${{ env.SHORT_SHA }}
ENV=${{ env.ENV }}

cd helm-chart

echo "Updating tag to ${TAG_VERSION} in environment: ${ENV}"
for dir in "${DIRECTORIES[@]}"; do
  if [ -f "helm-chart/$dir/values-${ENV}.yaml" ]; then
    echo "Updating tag in helm-chart/$dir/values-${ENV}.yaml"
    sed -i "s/tag: \".*\"/tag: \"${TAG_VERSION}\"/" "helm-chart/$dir/values-${ENV}.yaml"
  else
    echo "File helm-chart/$dir/values-${ENV}.yaml not found. Skipping."
  fi
done

git config --global user.email "github-actions@github.com"
git config --global user.name "GitHub Actions"

if [[ -n $(git status -s) ]]; then
  echo "Changes detected, committing..."
  git add .
  git commit -m "Update tag to ${TAG_VERSION} for ${ENV} environment"
  git push
  echo "Changes pushed successfully"
else
  echo "No changes detected, skipping commit"
fi