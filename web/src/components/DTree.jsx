import React, { useState } from 'react';
import Tree from 'react-d3-tree';
import '../Style/home.css'
// import { CircularProgressbar } from 'react-circular-progressbar';
// import 'react-circular-progressbar/dist/styles.css';
// import Profile from '../../../src/component/Profile';

const DTree = ({ data }) => {
  const [roll, setroll] = useState()
  const [showModal, setShowModal] = useState(false);
  const value = 0.5;

  const new_data = []
  const all_parent = {
    name: 'Research Visualisation',
    children: []
  }
  data = Object.values(data);
  data.forEach(item => {
    all_parent.children.push(item);
  });
  new_data.push(all_parent)
  console.log(new_data)

  const renderCustom = ({ nodeDatum, toggleNode, links }) => {
    const str = nodeDatum.name
    const name = str.slice(0, 19) + ''
    return (
      <g
        onMouseOut={() => handleNodeMouseOut(nodeDatum)}
        onMouseOver={() => handleNodeMouseOver(nodeDatum)}
      >

        <circle r={7} className='circlecolor' />
        <text
          textAnchor="middle"
          dy="24"
          dx='0'
          className='text_'
        >{name} </text>
      </g>

    )
  }
  const getLinkColor = (link) => {
    if (link.source.name.includes('root')) {
      return 'white';
    }
    return 'white';
  };

  const getLinkProps = (link) => ({
    stroke: getLinkColor(link),
    strokeWidth: 10,
  });

  const handleNodeMouseOver = (nodeDatum, event) => {
    if (nodeDatum.name !== 'All') {
      setroll(nodeDatum)
      setShowModal(true)

    }
  };
  const handleNodeMouseOut = (nodeData, event) => {
    if (nodeData.name !== 'All') {
      setShowModal(false)
    }
  };
  const dimensions = {
    width: 800,
    height: 600
  };
  return (
    <>
      {/* {showModal && (
        <Profile rollNo={roll.rollNo} />
      )} */}
      <Tree data={new_data}
        scaleExtent={{
          min: 0.25,
          max: 2
        }}
        zoom={1.5}
        zoomable={true}
        linkClassName={"custom-link"}
        // depthFactor={500}
        // linkProps={getLinkProps}
        initialDepth={1}
        // pathFunc="straight"
        nodeSize={{ x: 100, y: 60 }}
        translate={{ x: 900, y: 530 }}
        // draggable={false}
        // dimensions={dimensions}
        orientation={"vertical"}
        pathClassFunc={() => 'custom-link'}
        // renderCustomNodeElement={renderCustom}
        // transitionDuration={500}
        shouldCollapseNeighborNodes={false}
        separation={{ siblings: 2, nonSiblings: 2 }}
      // renderCustomLinkElement={renderCustomLink}

      />
    </>
  )
}

export default DTree
