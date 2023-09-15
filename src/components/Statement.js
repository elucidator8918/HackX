import React from "react";
import Threemodel from "./Threemodel";
import { Typewriter } from "react-simple-typewriter";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";

export default function Statement() {
  const navigate = useNavigate();
  return (
    <div className="overflow-hidden pt-6 sm:pt-18 no-scrollbar">
      <div className="mx-auto max-w-7xl px-10 lg:px-14">
        <div className="mx-auto grid max-w-2xl grid-cols-1  lg:mx-0 lg:max-w-none lg:grid-cols-2 ">
          <div className="lg:pl-12 h-screen flex items-center justify-center pb-10">
            <div className="lg:max-w-lg">
              <p className="md:text-8xl font-bold flex justify-center items-center tracking-tight bg-gradient-to-r from-cyan-500 to-teal-500 bg-clip-text text-transparent text-9xl">
                Correctify
              </p>
              <dl className="mt-4 max-w-9xl space-y-8 text-base leading-7 text-slate-200 lg:max-w-none">
                <p className="md:text-lg font-bold flex  tracking-tight bg-gradient-to-r from-gray-300 to-gray-200 bg-clip-text text-transparent text-xl">
                  <Typewriter
                    words={["AI-Powered and Ready to Transform Your Writing"]}
                    cursor
                    cursorStyle="."
                    loop={0}
                  />
                </p>
              </dl>
              <div className="flex mt-6">
                <button
                  className=" animate-bounce flex justify-center items-center text-sm font-bold leading-6 text-gray-100 text-bold py-3 px-12 bg-cyan-500 hover:bg-teal-500 rounded-md transition-all duration-150 ease-in-out border-1"
                  onClick={() => {
                    navigate("/signup");
                  }}
                >
                  Try our AI Assistant
                </button>
              </div>
            </div>
          </div>
          <Threemodel />
        </div>
      </div>
    </div>
  );
}
