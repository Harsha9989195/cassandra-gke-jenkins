pipeline {
  agent any
  options { timeout(time: 5, unit: 'MINUTES') }
  stages {
    stage('Check Cassandra Version') {
      steps {
        sh '''
          set -e
          KVER="v1.30.3"
          [ -x ./kubectl ] || { curl -sSfL https://dl.k8s.io/release/${KVER}/bin/linux/amd64/kubectl -o kubectl; chmod +x kubectl; }
          NS=cassandra
          POD=$(./kubectl -n $NS get pod -l app.kubernetes.io/name=cassandra -o jsonpath='{.items[0].metadata.name}')
          PASS=$(./kubectl -n $NS get secret cassandra -o jsonpath='{.data.cassandra-password}' | base64 -d)
          ./kubectl -n $NS exec -i "$POD" -- cqlsh -u cassandra -p "$PASS" -e "SELECT release_version FROM system.local;"
        '''
      }
    }
    stage('Feed Data (quick)') {
      steps {
        sh '''
          set -e
          NS=cassandra
          POD=$(./kubectl -n $NS get pod -l app.kubernetes.io/name=cassandra -o jsonpath='{.items[0].metadata.name}')
          PASS=$(./kubectl -n $NS get secret cassandra -o jsonpath='{.data.cassandra-password}' | base64 -d)

          # create keyspace & table (use fully-qualified names to avoid USE)
          ./kubectl -n $NS exec -i "$POD" -- cqlsh -u cassandra -p "$PASS" -e "CREATE KEYSPACE IF NOT EXISTS demo WITH replication={'class':'SimpleStrategy','replication_factor':1};"
          ./kubectl -n $NS exec -i "$POD" -- cqlsh -u cassandra -p "$PASS" -e "CREATE TABLE IF NOT EXISTS demo.users (id int PRIMARY KEY, name text);"

          # insert + verify
          ./kubectl -n $NS exec -i "$POD" -- cqlsh -u cassandra -p "$PASS" -e "INSERT INTO demo.users (id,name) VALUES (999,'demo-row');"
          ./kubectl -n $NS exec -i "$POD" -- cqlsh -u cassandra -p "$PASS" -e "SELECT id,name FROM demo.users WHERE id=999;"
        '''
      }
    }
  }
}

