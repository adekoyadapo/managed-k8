# """A Google Cloud Python Pulumi program"""

# import pulumi
# from pulumi_gcp import storage

# # Create a GCP resource (Storage Bucket)
# bucket = storage.Bucket('my-bucket', location="US")

# # Export the DNS name of the bucket
# pulumi.export('bucket_name', bucket.url)

import pulumi
import pulumi_gcp as gcp

primary = gcp.container.Cluster("demo",
    enable_autopilot=True,
    ip_allocation_policy=None,
    location="us-central1-a")