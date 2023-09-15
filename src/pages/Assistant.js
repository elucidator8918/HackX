import React from "react";
import { useState, useEffect } from "react";
import Mic from "../components/Mic";
import Navbar from "../components/Navbar";

export const Assistant = () => {
  return (
    <div className="flex flex-col">
      <Navbar />
      <Mic />
    </div>
  );
};
