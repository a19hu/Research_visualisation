from flask import Flask, jsonify, request
from neo4j import GraphDatabase

app = Flask(__name__)

URI = "neo4j://10.6.0.63:7687"
AUTH = ("neo4j", "neo4j@123")
employee_threshold = 10


driver = GraphDatabase.driver(URI, auth=AUTH)

@app.route('/users', methods=['GET'])
def get_users():
    with driver.session() as session:
        # Fetch all user nodes
        result = session.run("MATCH (u:User) RETURN u.name AS name, u.age AS age")
        users = [{"name": record["name"], "age": record["age"]} for record in result]
        return jsonify(users)
        

@app.route("/add_employee", methods=["POST"])
def add_employee():
    name = request.json.get("name")
    if not name:
        return jsonify({"error": "Name is required"}), 400

    with driver.session(database="neo4j") as session:
        try:
            org_id = session.write_transaction(employ_person_tx, name)
            return jsonify({"message": f"User {name} added to organization {org_id}"}), 201
        except Exception as e:
            return jsonify({"error": str(e)}), 500

def employ_person_tx(tx, name):
    # Create Person node
    tx.run("MERGE (p:Person {name: $name}) RETURN p.name AS name", name=name)

    # Find latest organization and count employees
    org = tx.run("""
        MATCH (o:Organization)
        RETURN o.id AS id, COUNT{(p:Person)-[:WORKS_FOR]->(o)} AS employees_n
        ORDER BY o.created_date DESC
        LIMIT 1
    """).single()

    # Add person to organization or create a new one
    if org and org["employees_n"] < employee_threshold:
        org_id = org["id"]
        tx.run("MATCH (o:Organization {id: $org_id}), (p:Person {name: $name}) MERGE (p)-[:WORKS_FOR]->(o)", org_id=org_id, name=name)
    else:
        result = tx.run("""
            MATCH (p:Person {name: $name})
            CREATE (o:Organization {id: randomuuid(), created_date: datetime()})
            MERGE (p)-[:WORKS_FOR]->(o)
            RETURN o.id AS id
        """, name=name)
        org_id = result.single()["id"]

    return org_id


if __name__ == "__main__":
    app.run(host='10.23.24.164', port=5000)
