# coherence
Coherence docker and kubernetes artifacts


# kubernetes on GCP
gcloud container clusters create k8s-coherence-cluster --machine-type=g1-small --num-nodes=3 --no-enable-autoupgrade --zone northamerica-northeast1-a --project superb-reporter-256719

gcloud container clusters get-credentials k8s-coherence-cluster --zone northamerica-northeast1-a --project superb-reporter-256719 

