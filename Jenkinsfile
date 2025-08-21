pipeline {
agent any
stages {
stage('Cassandra: insert & read') {
steps {
sh '''
curl -sSL https://dl.k8s.io/release/$(curl
 -sSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
 -o kubectl
chmod +x kubectl
NS=cassandra
PASS=$(./kubectl -n $NS get secret cassandra -o jsonpath='{.data.cassandra-password}' | base64 -d)
POD=$(./kubectl -n $NS get pod -l app.kubernetes.io/name=cassandra -o jsonpath='{.items[0].metadata.name}')
./kubectl -n $NS exec -i "$POD" -- bash -lc "cqlsh -u cassandra -p $PASS -e \"USE demo; INSERT INTO users(id,name) VALUES (2,'from-jenkins'); SELECT * FROM users;\""
'''
}
}
}
post { success { echo 'Data loaded & verified from Jenkins.' } }
}
