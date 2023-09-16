import React, { Suspense, useEffect, useState, useRef } from "react";
import { Canvas } from "@react-three/fiber";
import {
  OrbitControls,
  Preload,
  useGLTF,
  useAnimations,
} from "@react-three/drei";
import CanvasLoader from "./Loader";
import { motion } from "framer-motion";

const Computers = ({ isMobile }) => {
  const computer = useGLTF("./william_shakespeare_statue/scene.gltf");
  //#ede7ca
  return (
    <mesh>
      <ambientLight intensity={7} color="#a5f3fc" />
      <primitive
        object={computer.scene}
        scale={isMobile ? 2 : 2.25}
        position={isMobile ? [0, -3, -0.5] : [0, -1.3, -0.1]}
        rotation={[0, Math.PI / 2, 0]} // Rotate around the center plane
      />
    </mesh>
  );
};

const Threemodel = () => {
  const [isMobile, setIsMobile] = useState(false);
  const canvasRef = useRef();

  useEffect(() => {
    const handleMediaQueryChange = (event) => {
      setIsMobile(event.matches);
    };

    const mediaQuery = window.matchMedia("(max-width: 1000px)");
    setIsMobile(mediaQuery.matches);
    mediaQuery.addEventListener("change", handleMediaQueryChange);

    return () => {
      mediaQuery.removeEventListener("change", handleMediaQueryChange);
    };
  }, []);

  return (
    <Canvas
      ref={canvasRef}
      shadows
      dpr={[1, 2]}
      camera={{ position: isMobile ? [25, 0, 25] : [20, 3, 0], fov: 20 }}
      gl={{ preserveDrawingBuffer: true }}
    >
      <Suspense fallback={<CanvasLoader />}>
        <OrbitControls
          enableZoom={false}
          enablePan={false}
          rotateSpeed={0.5} // Adjust rotation speed
          target={[0, 0, 0]} // Set rotation center
          minDistance={10} // Minimum distance from the center
          maxDistance={30} // Maximum distance from the center
          minPolarAngle={Math.PI / 6} // Limit rotation angle from top view
          maxPolarAngle={Math.PI / 2.6} // Limit rotation angle from bottom view
          autoRotate
          autoRotateSpeed={0.5} // Adjust auto-rotation speed
        />
        <Computers isMobile={isMobile} />
      </Suspense>
      <Preload all />
    </Canvas>
  );
};

export default Threemodel;
