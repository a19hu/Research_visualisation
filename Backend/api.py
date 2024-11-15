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
    nodes = [node for node in path.nodes]
    relationships = [rel for rel in path.relationships]
    
    serialized_nodes = [{"labels": list(node.labels), "properties": dict(node)} for node in nodes]
    serialized_relationships = [{"type": rel.type, "properties": dict(rel)} for rel in relationships]
    
    return {
        "nodes": serialized_nodes,
        "relationships": serialized_relationships
    }

@app.route('/fetchtree', methods=['GET'])
def get_tree():
    with driver.session() as session:
        result1 = session.run("MATCH p=()-[r:topic_prof]->() RETURN p ")
        result2 = session.run("MATCH p=()-[r:PROJECT_BY]->() RETURN p ")
        result3 = session.run("MATCH p=()-[r:ENROLLED_IN]->() RETURN p")


MATCH (t:Movie{title:"Toy Story"})<-[:ACTED_IN]-(a:Actor)-[:ACTED_IN]->(m:Movie) RETURN a.name, m.title

        
        data1 = [serialize_path(record["p"]) for record in result1]
        data2 = [serialize_path(record["p"]) for record in result2]
        data3 = [serialize_path(record["p"]) for record in result3]

    combined_data = data1 + data2 + data3

    response = {
        "status": "success",
        "message": "Fetched relationships successfully",
        "data": combined_data
    }

    return jsonify(response)


# Research Topic api

@app.route('/fetchResearchtopic', methods=['GET'])
def get_topic():
    with driver.session() as session:
        result = session.run("MATCH (m:Research_TOPIC) RETURN CASE WHEN m IS NOT NULL THEN m.name ELSE 'No reseasrch found' END AS name")
        print(result)
        users = [{"name": record["name"]} for record in result]
        return jsonify(users)


@app.route('/createresearchdata', methods=['POST'])
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


@app.route('/postresearchdata', methods=['POST'])
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

@app.route('/removesearchdata', methods=['POST'])
def remove_topic_prof():
    data = request.get_json()
    name = data.get('name')
    uid=data.get('uid')
    query = """
    MATCH (n:Research_TOPIC {name: $name})-[r:topic_prof]->(m:prof {uid: $uid})
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

@app.route('/deleteresearchdata', methods=['POST'])
def delete_topic_prof():
    data = request.get_json()
    name = data.get('name')
    uid=data.get('uid')
    query = """
    MATCH (n:Research_TOPIC {name: $name})-[r:topic_prof]->(m:prof {uid: $uid})
    DELETE r,n
    RETURN n, m
    """
    with driver.session() as session:
        result = session.run(query, name=name,uid=uid)

    response_data = {
        "status": "success",
        "message": "Data received successfully",
    }

    return jsonify(response_data)



# Project api


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

@app.route('/createproject', methods=['POST'])
def add_topic_project():
    data = request.get_json()
    name = data.get('name')
    uid=data.get('uid')

    query = """
    MATCH (n:Project {name: $name}), (m:prof {uid: $uid})
    MERGE (n)-[:PROJECT_BY]->(m)
    RETURN n, m
    """

    with driver.session() as session:
        result = session.run(query, name=name,uid=uid)

    response_data = {
        "status": "success",
        "message": "Data received successfully",
    }

    return jsonify(response_data)


@app.route('/postproject', methods=['POST'])
def add_project():
    data = request.get_json()
    name = data.get('name')
    topicname=data.get("topicname")
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

@app.route('/removeproject', methods=['POST'])
def remove_project():
    data = request.get_json()
    name = data.get('name')
    uid=data.get('uid')
    query = """
    MATCH (n:Project {name: $name})-[r:PROJECT_BY]->(m:prof {uid: $uid})
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


# Student api



@app.route('/fetchstudents', methods=['GET'])
def get_students():
    with driver.session() as session:
        result = session.run("""OPTIONAL MATCH (m:Students)
RETURN m.name AS name,m.url AS url, m.uid AS uid,m.projectname AS projectname,m.email AS email""")
        users = [{"name": record["name"], "url" : record["url"],"uid":record["uid"],"email":record["email"],"projectname":record["projectname"]} for record in result]
        return jsonify(users)


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
    (m:prof {uid: $uid}) 
    MERGE (n)-[:ENROLLED_IN]->(p)
    MERGE (p)-[:PROJECT_BY]->(m)
    RETURN n
    """
    with driver.session() as session:
        result = session.run(query, name=name ,email=email,url=url,uid=uid,projectname=projectname)

    response_data = {
        "status": "success",
        "message": "Data received successfully",
    }

    return jsonify(response_data)

@app.route('/removestudent', methods=['POST'])
def remove_student():
    data = request.get_json()
    name = data.get('name')
    email=data.get('email')
    projectname=data.get('projectname')
    print(name,email,projectname)
    query = """
    MATCH (n:Students {name: $name,email:$email,projectname:$projectname})-[r:ENROLLED_IN]->(m:Project)
    DELETE r,n
    RETURN n, m
    """
    with driver.session() as session:
        result = session.run(query, name=name,projectname=projectname,email=email)

    response_data = {
        "status": "success",
        "message": "Data received successfully",
    }

    return jsonify(response_data)

# Admin api

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


@app.route('/updateadmin', methods=['POST'])
def update_admin():
    data = request.get_json()
    name = data.get('name')
    uid=data.get('uid')
    url=data.get('url')
    query = """
    MERGE (n:prof {uid: $uid})
    ON CREATE SET n.name = $name, n.url = $url
    ON MATCH SET n.name = $name, n.url = $url
    RETURN n
    """
    with driver.session() as session:
        result = session.run(query, name=name ,uid=uid,url=url)

    response_data = {
        "status": "success",
        "message": "Data received successfully",
    }

    return jsonify(response_data)





if __name__ == "__main__":
    app.run(host='10.23.24.164', port=5000)
    # app.run(debug=true)
