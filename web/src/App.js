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
        const response = await axios.get(`https://devluplabs.iitj.ac.in/ftadmin/tree/`);
        setData(response.data);
      } catch (error) {
        seterror(true)
      }
    };
    fetchData();
  }, []);

  
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
