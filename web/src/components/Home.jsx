import React from 'react'
import background from '../image/b1.jpg'
// import DTree from './DTree'
import '../Style/home.css'
import DTree from './DTree';
export default function Home({data}) {
 
    const mystyle={
      backgroundImage: `url(${background})`,
      backdropFilter: "blur(6px)",
      backgroundSize: "cover",
      backgroundRepeat: "no-repeat",
      height: "100vh",
      opacity: '0.8',
     };
    return (
  
      <>
      <div className="home" style={mystyle} >
      </div>
     <div className="typewriterStyle" >
        <DTree data={data}/>  
    </div>
      </>
  )
}
