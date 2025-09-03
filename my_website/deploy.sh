#!/bin/bash

# Exit if any command fails
set -e

# Your bucket name
S3_BUCKET="my-hugo-web-bucket-portfolio"

# Optional: CloudFront distribution ID (leave empty if not using CloudFront)
CLOUDFRONT_ID=""

echo "👉 Building Hugo site..."
hugo --minify

echo "👉 Syncing files to S3 bucket: $S3_BUCKET"
aws s3 sync public/ s3://$S3_BUCKET --delete

# If CloudFront ID is set, invalidate cache
if [ -n "$CLOUDFRONT_ID" ]; then
  echo "👉 Invalidating CloudFront cache..."
  aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_ID --paths "/*"
fi

echo "✅ Deployment complete!"
