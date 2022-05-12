import pulumi
import pulumi_gcp as gcp

default = gcp.service_account.Account("default",
    account_id="service-account-id",
    display_name="Service Account")
primary = gcp.container.Cluster("primary",
    enable_autopilot=True,
    location="us-central1-a")