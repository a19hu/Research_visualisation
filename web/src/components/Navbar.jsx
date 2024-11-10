import "../Style/navbar.css";
import { Link } from "react-router-dom";
import logo from "../image/IIT-Logo.png";
import React, { useState } from "react";

function Navbar() {
  return (
    <div className="fixed w-[100%] z-50">
      <div className="header px-[20%] py-[10px] max-md:px-[5%] max-lg:px-[5%] max-xl:px-[10%]">
        <div className="logo">
          <Link to='/'>
            <img src={logo} alt="Logo" />
          </Link>
        </div>
        <div className="app_link">
          <div className="treeD">
            <Link to="/" style={window.location.pathname === '/' ? { color: 'black' } : null}>
              Home
            </Link>
          </div>
          <div className="treeD">
            <Link to="/ImageTree" style={window.location.pathname === '' ? { color: 'black' } : null}>
              App
            </Link>
          </div>

        </div>
      </div>
    </div>

  );
}

export default Navbar;
