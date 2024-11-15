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
        result = session.run("MATCH (u:User) RETURN u.name AS name, u.age AS age")
        result1 = session.run("MATCH (u:User)-[r1:HAS_POST]->(p:Post) OPTIONAL MATCH (u)-[r2:KNOWS]->(f:User) RETURN u, p, f, type(r1) as postRelationship, type(r2) as knowsRelationship ")
        users = [{"name": record["name"], "age": record["age"]} for record in result]
        return jsonify(users)

@app.route('/fetchResearchtopic', methods=['GET'])
def get_topic():
    with driver.session() as session:
        result = session.run("MATCH (m:Research_TOPIC) RETURN CASE WHEN m IS NOT NULL THEN m.name ELSE 'No reseasrch found' END AS name")
        print(result)
        users = [{"name": record["name"]} for record in result]
        return jsonify(users)
        
@app.route('/fetchProject', methods=['GET'])
def get_Project():
    with driver.session() as session:
        result = session.run("""OPTIONAL MATCH (m:Project)
RETURN 
  m.name AS name, 
  m.topicname AS topicname""")
        print(result)
        users = [{"name": record["name"], "topicname" : record["topicname"]} for record in result]
        return jsonify(users)

@app.route('/add_topic_prof', methods=['POST'])
def add_topic_prof():
    data = request.get_json()
    name = data.get('name')
    uid=data.get('uid')

    query = """
    MATCH (n:Research_TOPIC {name: $name}), (m:prof {uid: $uid})
    MERGE (n)-[:topic_prof]->(m)
    RETURN n, m

    """

    with driver.session() as session:
        result = session.run(query, name=name,uid=uid)

    response_data = {
        "status": "success",
        "message": "Data received successfully",
    }

    return jsonify(response_data)

@app.route('/delete_topic_prof', methods=['POST'])
def delete_topic_prof():
    data = request.get_json()
    name = data.get('name')
    uid=data.get('uid')

    query = """
    MATCH (n:Research_TOPIC {name: $name}), (m:prof {uid: $uid})
    OPTIONAL MATCH (n)-[r:topic_prof]->(m)
    DELETE r
    RETURN n, m
    """

    with driver.session() as session:
        result = session.run(query, name=name,uid=uid)

    response_data = {
        "status": "success",
        "message": "Data received successfully",
    }

    return jsonify(response_data)


@app.route('/add_post', methods=['POST'])
def add_research():
    data = request.get_json()
    name = data.get('name')
    query = """
    CREATE (n:Research_TOPIC {name: $name})
    RETURN n
    """
    with driver.session() as session:
        result = session.run(query, name=name)

    response_data = {
        "status": "success",
        "message": "Data received successfully",
    }

    return jsonify(response_data)


@app.route('/add_project', methods=['POST'])
def add_project():
    print('hii')
    data = request.get_json()
    name = data.get('name')
    topicname=data.get('topicname')
    query = """
    CREATE (n:Project {name: $name,topicname:$topicname})
    RETURN n
    """
    with driver.session() as session:
        result = session.run(query, name=name,topicname=topicname)

    response_data = {
        "status": "success",
        "message": "Data received successfully",
    }

    return jsonify(response_data)

@app.route('/add_admin', methods=['POST'])
def add_admin():
    data = request.get_json()
    name = data.get('name')
    uid=data.get('uid')
    url=data.get('url')
    email=data.get('email')
    query = """
    CREATE (n:prof {name: $name, uid: $uid, url: $url, email: $email})
    RETURN n
    """
    with driver.session() as session:
        result = session.run(query, name=name ,uid=uid,email=email,url=url)

    response_data = {
        "status": "success",
        "message": "Data received successfully",
    }

    return jsonify(response_data)


@app.route('/add_student', methods=['POST'])
def add_student():
    data = request.get_json()
    name = data.get('name')
    url=data.get('url')
    email=data.get('email')
    query = """
    CREATE (n:prof {name: $name, url: $url, email: $email})
    RETURN n
    """
    with driver.session() as session:
        result = session.run(query, name=name ,email=email,url=url)

    response_data = {
        "status": "success",
        "message": "Data received successfully",
    }

    return jsonify(response_data)

if __name__ == "__main__":
    app.run(host='10.23.24.164', port=5000)
