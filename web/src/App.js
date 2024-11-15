import './App.css';
import { BrowserRouter, Route, Routes } from "react-router-dom";
import React, { useEffect, useState } from 'react';
import axios from 'axios';
import Home from './components/Home';
import Navbar from './components/Navbar';

function App() {
  const [data, setData] = useState([]);
  const [error,seterror]=useState(false)
 useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await axios.get(`http://10.23.24.164:5000/fetchtree`);
        setData(response.data.data);
        console.log(createTree(response.data.data))
      } catch (error) {
        seterror(true)
      }
    };
    fetchData();
  }, []);

  function createTree(data) {
    const tree = {};
    data.forEach((item) => {
      console.log(item)
      const nodes = item.nodes;
      const relationship = item.relationships[0].type;
  
      if (relationship === "topic_prof") {
        const topic = nodes[0].properties.name;
        const professor = nodes[1].properties;
  
        tree[topic] = {
          professor: professor,
          projects: {},
        };
      } else if (relationship === "PROJECT_BY") {
        const topic = nodes[1].properties.topicname;
        const project = nodes[0].properties;
  
        if (tree[topic]) {
          tree[topic].projects[project.name] = {
            students: [],
          };
        }
      } else if (relationship === "ENROLLED_IN") {
        const project = nodes[1].properties.name;
        const student = nodes[0].properties;
  
        Object.keys(tree).forEach((topic) => {
          if (tree[topic].projects[project]) {
            tree[topic].projects[project].students.push(student);
          }
        });
      }
    });
  
    return tree;
  }
  
  return (
    <BrowserRouter
 basename="/"
	  >
    <Navbar/>
   <Routes>
     <Route path="/" element={<Home data={data}/>} />
   </Routes>
 </BrowserRouter>
  );
}

export default App;
