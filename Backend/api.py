from flask import Flask, jsonify, request
from neo4j import GraphDatabase
from flask_cors import CORS
import neo4j
app = Flask(__name__)
URI = "neo4j://10.6.0.63:7687"
AUTH = ("neo4j", "neo4j@123")
employee_threshold = 10

CORS(app, resources={
    r"/*": {"origins": ["http://localhost:3000","http://10.23.24.164:3000","https://research-visualisation.vercel.app","http://10.6.0.63:3000/"]}
})

driver = GraphDatabase.driver(URI, auth=AUTH)

@app.route('/fetchtree', methods=['GET'])
def get_tree():
    with driver.session() as session:
        result1 = session.run("""MATCH (research_topic:Research_TOPIC)
        OPTIONAL MATCH (research_topic)-[:topic_prof]->(prof:prof)
        OPTIONAL MATCH (prof)-[:PROJECT_BY]->(project:Project)
        OPTIONAL MATCH (project)-[:ENROLLED_IN]->(student:Students)
        RETURN research_topic, prof, project, student""")
        result=build_tree(result1)
        # for record in result1:
        #     print(record)
        #     print("11")

    response_data = {
        "status": "success",
        "message": "Data received successfully",
        "data":result
    }

    return jsonify(response_data)

def build_tree(data):
    tree = {}
    for record in data:
        # Get or create the research topic node
        research_topic_name = record["research_topic"]["name"]
        
        # Create the research topic node if it doesn't exist
        if research_topic_name not in tree:
            tree[research_topic_name] = {"name": research_topic_name, "children": []}

        # Handle professor if exists
        if record["prof"]:
            professor_uid = record["prof"]["uid"]
            professor_data = {
                "uid": professor_uid,
                "name": record["prof"]["name"],
                "url": record["prof"]["url"],
                "email": record["prof"]["email"],
                "children": [],
            }

            # Check if the professor already exists in the tree
            professor_in_tree = next(
                (prof for prof in tree[research_topic_name]["children"] if prof["uid"] == professor_uid), None
            )
            if not professor_in_tree:
                tree[research_topic_name]["children"].append(professor_data)
                professor_in_tree = professor_data

            # Handle project if exists and its topic matches the research topic
            if record["project"]:
                project_name = record["project"]["name"]
                project_topicname = record["project"]["topicname"]
                
                # Only add project if the topicname matches the research_topic_name
                if project_topicname == research_topic_name:
                    project_data = {
                        "name": project_name,
                        "topicname": project_topicname,
                        "children": [],
                    }

                    # Check if the project already exists under the professor
                    project_in_tree = next(
                        (proj for proj in professor_in_tree["children"] if proj["name"] == project_name), None
                    )
                    if not project_in_tree:
                        professor_in_tree["children"].append(project_data)
                        project_in_tree = project_data

                    # Handle student if exists
                    if record["student"]:
                        student_uid = record["student"]["uid"]
                        student_data = {
                            "uid": student_uid,
                            "name": record["student"]["name"],
                            "projectname": record["student"]["projectname"],
                            "url": record["student"]["url"],
                            "email": record["student"]["email"],
                        }

                        # Check if the student already exists under the project
                        if student_data not in project_in_tree["children"]:
                            project_in_tree["children"].append(student_data)

    return tree


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
        users = [{"name": record["name"], "topicname" : record["topicname"]} for record in result]
        return jsonify(users)

@app.route('/createproject', methods=['POST'])
def add_topic_project():
    data = request.get_json()
    name = data.get('name')
    uid=data.get('uid')

    query = """
    MATCH (n:Project {name: $name}), (m:prof {uid: $uid})
    MERGE (m)-[:PROJECT_BY]->(n)
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
    MATCH (n:Project {name: $name})<-[r:PROJECT_BY]-(m:prof {uid: $uid})
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
    MERGE (p)-[:ENROLLED_IN]->(n)
    MERGE (m)-[:PROJECT_BY]->(p)
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
    MATCH (n:Students {name: $name,email:$email,projectname:$projectname})<-[r:ENROLLED_IN]-(m:Project)
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
    app.run(host='10.23.25.97', port=5000)
    # app.run(debug=true)
