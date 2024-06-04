# Assessment
### My environment:
```
host = macbook
docker = Docker Desktop
Kubernetes = Docker Desktop extension
IaC = Terraform
```

## Problem statement
```
Create a Kubernetes cron job that pulls node metrics like (CPU, Memory, Disk usage) and stores them in a file.

Every time the cron runs, it should create a new file. The filename should have the current timestamp.
By default, cron should be minute, but it should be configurable with the slightest changes to code.
Choose a tool of your choice to collect and expose metrics. Preferable is node exporter.
The instances involved here are Kubernetes nodes themselves.
Expected Output:

The actual program code pulls the metrics and writes them to a file.
The Dockerfile to containerize the code.
Kubernetes YAML or HELM Chart.
A README file explaining the design, deployment and other details.
If possible, record a short video to demo the output with the code files.
Note :

Pick the choice of your language to write the cron job. Preferable is bash.
Treat the output files generated as essential and should be retained on pod restarts.
Deployment can either be Kube yamls, helm charts, kustomize.
You can make necessary assumptions if required and document them.
Choose local kubernetes setup like minikube, kind. Other option is to pick any cloud platform's kubernetes flavour.
```

## Steps
There are 3 major tasks in this assignment.
1. Use a node-exporter to get the node metrics (CPU, Mem, Disk-usage)
2. Run a kubernetes cronjob every min to read the metrics
3. Read metrics and write them to a file, append the filename with datetime stamp


### Part 1
We will use the `prometheus-node-exporter` package provided by `prometheus-community` and install it via helm.
I already have the prometheus-community added to my local, just in case if you want to add it, use below cmd:
`helm repo add prometheus-community https://prometheus-community.github.io/helm-charts`

  ```
  helm repo list
  NAME                    URL                                               
  prometheus-community    https://prometheus-community.github.io/helm-charts
  ingress-nginx           https://kubernetes.github.io/ingress-nginx
  ```

We can look at the `node-exporter` chart provided by `promethues`
  ```
  helm search repo node-exporter
  NAME                                            CHART VERSION   APP VERSION     DESCRIPTION                              
  prometheus-community/prometheus-node-exporter   4.34.0          1.8.0           A Helm chart for prometheus node-exporter
  ```

We will deploy `node-exporter` using helm which will scrape the required metrics.

For the purpose of this assignment and tracking the code, let's templatize the helm chart to maintain the source of truth
  ```
  helm template one2n-lab1 prometheus-node-exporter \
  --repo https://prometheus-community.github.io/helm-charts \
  --namespace one2n \
  > one2n_node_exporter.yaml
  ```

Before creating the objects, lets update the `Service` section to use `serviceType: LoadBalancer` to be able to access it from browser
  ```
  kubectl apply -f one2n_node_exporter.yaml
  ```

We can see, following objects are created:
  ```
  kubectl get all -n one2n                 
  NAME                                            READY   STATUS    RESTARTS   AGE
  pod/one2n-lab1-prometheus-node-exporter-47fp8   1/1     Running   0          3m19s
  
  NAME                                          TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
  service/one2n-lab1-prometheus-node-exporter   LoadBalancer   10.106.51.83   localhost     9100:30612/TCP   3m19s
  
  NAME                                                 DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
  daemonset.apps/one2n-lab1-prometheus-node-exporter   1         1         1       1            1           kubernetes.io/os=linux   3m19s
  ```

