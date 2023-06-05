#!/bin/bash

# Ask for confirmation to uninstall existing resources
read -p "Do you want to uninstall existing resources? (y/n) " answer
case ${answer:0:1} in
    y|Y )
        # Uninstall existing resources
        microk8s.kubectl delete -f resources/
    ;;
    * )
        # Skip uninstalling existing resources
        echo "Skipping uninstallation of existing resources."
    ;;
esac

# Install new resources
microk8s.kubectl apply -f resources/configmap.yaml
microk8s.kubectl apply -f resources/pv.yaml
microk8s.kubectl apply -f resources/pvc.yaml
microk8s.kubectl apply -f resources/deployment.yaml
microk8s.kubectl apply -f resources/service.yaml

# Get pod name
POD_NAME=$(microk8s.kubectl get pods -l app=postgres-unit-testing -o jsonpath='{.items[0].metadata.name}')

# Get username, password and database name from configmap
POSTGRES_USER=$(microk8s.kubectl get configmap postgres-unit-testing-configmap -o jsonpath='{.data.POSTGRES_USER}')
POSTGRES_PASSWORD=$(microk8s.kubectl get configmap postgres-unit-testing-configmap -o jsonpath='{.data.POSTGRES_PASSWORD}')
POSTGRES_DB=$(microk8s.kubectl get configmap postgres-unit-testing-configmap -o jsonpath='{.data.POSTGRES_DB}')

# Get node port of service
NODE_PORT=$(microk8s.kubectl get service postgres-unit-testing-service -o jsonpath='{.spec.ports[0].nodePort}')

# Get IP address of node or use default value
IP_ADDRESS=${IP_ADDRESS:-141.94.74.199}

# Initialize the pod status
POD_STATUS=""

# Loop until the pod is running
while [ "$POD_STATUS" != "Running" ]; do
  # Get the status of the pod
  POD_STATUS=$(microk8s.kubectl get pod $POD_NAME -o jsonpath='{.status.phase}')

  # Check if the pod is running
  if [ "$POD_STATUS" == "Running" ]; then
    # Break the loop
#    echo "Pod is running. Breaking loop."
#    microk8s kubectl cp init.sql ${POD_NAME}:/root/init.sql
#    microk8s.kubectl exec ${POD_NAME} -- psql -f /root/init.sql -U ${POSTGRES_USER} -d ${POSTGRES_DB}
     echo
     echo "Connection details:"
    break
  else
    # Wait for some time
    echo "Waiting for pod to be in Running state to display connection details."
    sleep 15
  fi
 done

# Output connection string
echo
echo "HOST: ${IP_ADDRESS}"
echo "PORT: ${NODE_PORT}"
echo "DATABASE: ${POSTGRES_DB}"
echo "USER: ${POSTGRES_USER}"
echo "PASSWORD: ${POSTGRES_PASSWORD}"
echo
echo "Connection string: Server=${IP_ADDRESS};Port=${NODE_PORT};Database=${POSTGRES_DB};User Id=${POSTGRES_USER};Password=${POSTGRES_PASSWORD}"

echo "===================================================" >> connection-string.txt
echo "HOST: ${IP_ADDRESS}" >> connection-string.txt
echo "PORT: ${NODE_PORT}" >> connection-string.txt
echo "DATABASE: ${POSTGRES_DB}" >> connection-string.txt
echo "USER: ${POSTGRES_USER}" >> connection-string.txt
echo "PASSWORD: ${POSTGRES_PASSWORD}" >> connection-string.txt
echo "Connection string: Server=${IP_ADDRESS};Port=${NODE_PORT};Database=${POSTGRES_DB};User Id=${POSTGRES_USER};Password=${POSTGRES_PASSWORD}" >> connection-string.txt
