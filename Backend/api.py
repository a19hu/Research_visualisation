from flask import Flask, jsonify, request
from neo4j import GraphDatabase
from flask_cors import CORS

app = Flask(__name__)
URI = "neo4j://10.6.0.63:7687"
AUTH = ("neo4j", "neo4j@123")
employee_threshold = 10

CORS(app, resources={
    r"/*": {"origins": ["http://localhost:3000","http://10.23.24.164:3000","https://research-visualisation.vercel.app/"]}
})

driver = GraphDatabase.driver(URI, auth=AUTH)

def serialize_path(path):
    # Extract nodes and relationships
    nodes = [node for node in path.nodes]
    relationships = [rel for rel in path.relationships]
    
    # Serialize the nodes and relationships (you can customize this as needed)
    serialized_nodes = [{"labels": list(node.labels), "properties": dict(node)} for node in nodes]
    serialized_relationships = [{"type": rel.type, "properties": dict(rel)} for rel in relationships]
    
    # Return the serialized data
    return {
        "nodes": serialized_nodes,
        "relationships": serialized_relationships
    }

@app.route('/fetchtree', methods=['GET'])
def get_tree():
    with driver.session() as session:
        # Run your queries
        result1 = session.run("MATCH p=()-[r:ENROLLED_IN]->() RETURN p LIMIT 25")
        result2 = session.run("MATCH p=()-[r:RESEARCH_PROJECT]->() RETURN p LIMIT 25")
        result3 = session.run("MATCH p=()-[r:ADVISED_BY]->() RETURN p LIMIT 25")
        
        # Serialize the paths
        data1 = [serialize_path(record["p"]) for record in result1]
        data2 = [serialize_path(record["p"]) for record in result2]
        data3 = [serialize_path(record["p"]) for record in result3]

    # Combine the data
    combined_data = data1 + data2 + data3

    response = {
        "status": "success",
        "message": "Fetched relationships successfully",
        "data": combined_data
    }

    return jsonify(response)

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

@app.route('/fetchstudents', methods=['GET'])
def get_students():
    print('hii')
    with driver.session() as session:
        result = session.run("""OPTIONAL MATCH (m:Students)
            RETURN 
                m.name AS name,
                m.url AS url,
                m.uid AS uid,
                m.projectname AS projectname,
                m.email AS email""")
        users = [{"name": record["name"], "url" : record["url"],"uid":record["uid"],"email":record["email"],"projectname":record["projectname"]} for record in result]
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
    MATCH (n:Research_TOPIC {name: $name})
    DETACH DELETE n
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
    data = request.get_json()
    name = data.get('name')
    topicname=data.get('topicname')
    query = """
    CREATE (n:Project {name: $name, topicname: $topicname})
    WITH n
    MATCH (p:Research_TOPIC {name: $topicname})
    CREATE (n)-[:RESEARCH_PROJECT]->(p)
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
    uid= data.get('uid')
    projectname = data.get('projectname')
    query = """
    CREATE (n:Students {name: $name, url: $url, email: $email,uid:$uid,projectname:$projectname})
    WITH n

MATCH (p:Project {name: $projectname}), 
      (prof:prof {uid: $uid})

CREATE (n)-[:ENROLLED_IN]->(p)
CREATE (n)-[:ADVISED_BY]->(prof)
CREATE (prof)-[:PROJECT_BY]->(p)


RETURN n
    """
    with driver.session() as session:
        result = session.run(query, name=name ,email=email,url=url,uid=uid,projectname=projectname)

    response_data = {
        "status": "success",
        "message": "Data received successfully",
    }

    return jsonify(response_data)



if __name__ == "__main__":
    # app.run(host='10.23.24.164', port=5000)
    app.run(debug=true)
