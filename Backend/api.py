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
        print("hii")
        print(result1)
        for record in result1:
            print(record)
        users = [{"name": record["name"], "age": record["age"]} for record in result]
        return jsonify(users)
        


@app.route('/add_post', methods=['POST'])
def add_admin():
    print('enter')
    data = request.get_json()
    # email = data.get('email')
    # url = data.get('url')
    name = data.get('name')
    print(data)

    # query = """
    # MERGE (u:User {email: $email, name: $name, url: $url})
    # MERGE (u)-[:HAS_POST]->(p)
    # RETURN u, p
    # """

    # # Execute the query
    # with driver.session() as session:
    #     result = session.run(query, email=email, url=url, name=name, post_content=post_content)
    #     user_node = result.single()["u"]
    #     post_node = result.single()["p"]

    # # Return a response
    # return jsonify({
    #     "user": {"email": user_node["email"], "name": user_node["name"], "url": user_node["url"]},
    #     "post": {"content": post_node["content"], "timestamp": post_node["timestamp"]}
    # })
    response_data = {
        "status": "success",
        "message": "Data received successfully",
        # Echoing back the received data
    }

    # Return the JSON response
    return jsonify(response_data)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
