# coherence
Coherence docker and kubernetes artifacts


## kubernetes on GCP

⋅⋅* kubectl: create cluster
```
gcloud container clusters create k8s-coherence-cluster --machine-type=g1-small --num-nodes=3 --no-enable-autoupgrade --zone northamerica-northeast1-a --project superb-reporter-256719
```

⋅⋅* kubectl: login to cluster 
```
gcloud container clusters get-credentials k8s-coherence-cluster --zone northamerica-northeast1-a --project superb-reporter-256719 
```
