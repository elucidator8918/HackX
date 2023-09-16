import React from "react";
import { Link, useNavigate } from "react-router-dom";
import { useEffect, useState, useRef } from "react";
import { Typewriter } from "react-simple-typewriter";
import Navbar from "../components/Navbar";
import ReCAPTCHA from "react-google-recaptcha";
import Webcam from "react-webcam";
import axios from "axios";
import { calculateNewValue } from "@testing-library/user-event/dist/utils";

const videoConstraints = {
  width: 100,
  height: 100,
  facingMode: "user",
  mirrored: "False",
};
const Signup = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  let flag = false;
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [file, setFile] = useState("");
  const webcamRef = React.useRef(null);

  const handleFileChange = async () => {
    const imageSrc = webcamRef.current.getScreenshot();
    // Create a blob from the base64-encoded data
    const blob = await (await fetch(imageSrc)).blob();
    // Create a File object from the blob
    const file = new File([blob], "image.jpg", { type: "image/jpeg" });
    setFile(file);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    // console.log(firstName);
    // console.log(lastName);
    // console.log(email);
    // console.log(password);
    // console.log(file);
    const formData = new FormData();
    formData.append("first_name", firstName);
    formData.append("last_name", lastName);
    formData.append("email", email);
    formData.append("password", password);
    formData.append("img", file);

    const res = await axios.post(
      "https://4fc9-35-236-195-116.ngrok-free.app/signup/",
      formData,
      {
        headers: {
          "Content-Type": `multipart/form-data`,
        },
      }
    );
    console.log(res);

    if (res.status === 200) {
      flag = true;
      localStorage.setItem("flag", flag);
      console.log(flag);
      navigate("/login");
    } else {
      console.log("wrong pass");
    }
  };

  /* const capture = React.useCallback(async() => {
 const imageSrc = webcamRef.current.getScreenshot();
 set(imageSrc);
 // Create a blob from the base64-encoded data
 const blob = await (await fetch(imageSrc)).blob();

 // Create a File object from the blob
const file = new File([blob], 'image.jpg', { type: 'image/jpeg' });



}); */

  //THE CAPTCHA PART
  const key = "6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI";
  const [captchaIsDone, setCaptchaDone] = useState(false);
  function onChange() {
    setCaptchaDone(true);
  }

  return (
    <div className="py-20 bg-gray-950">
      <div className="flex flex-col items-center mx-auto justify-center h-screen bg-gray-950 text-black overflow-y-auto">
        <Navbar />
        <div className="absolute ">
          <div className="text-3xl font-bold mb-4 mt-6 text-white flex justify-center items-center">
            <Typewriter words={["Signup"]} cursor cursorStyle="_" loop={0} />
          </div>
          <form onSubmit={handleSubmit} className="w-full">
            <div className="flex flex-grid">
              <div className="flex flex-wrap mb-4">
                <div className="w-full m-2">
                  <label
                    htmlFor="first-name"
                    className="flex mb-2 font-bold text-white"
                  >
                    First Name:
                  </label>
                  <input
                    type="text"
                    id="first-name"
                    className="border border-gray-400 p-2 w-full rounded-lg bg-cyan-100 placeholder-black text-black"
                    value={firstName}
                    placeholder="First Name"
                    onChange={(e) => setFirstName(e.target.value)}
                  />
                </div>
                <div className="w-full m-2">
                  <label
                    htmlFor="last-name"
                    className="flex mb-2 font-bold text-white"
                  >
                    Last Name:
                  </label>
                  <input
                    type="text"
                    id="last-name"
                    className="border border-gray-400 p-2 w-full rounded-lg bg-cyan-100 placeholder-black text-black"
                    value={lastName}
                    placeholder="Last Name"
                    onChange={(e) => setLastName(e.target.value)}
                  />
                </div>
              </div>
              <div className="flex flex-wrap mb-4">
                <div className="w-full m-2">
                  <label
                    htmlFor="email"
                    className="flex mb-2 font-bold text-white"
                  >
                    Email:
                  </label>
                  <input
                    type="email"
                    id="email"
                    className="border border-gray-400 p-2 w-full rounded-lg bg-cyan-100 placeholder-black text-black"
                    value={email}
                    placeholder="Email"
                    onChange={(e) => setEmail(e.target.value)}
                  />
                </div>
                <div className="w-full m-2">
                  <label
                    htmlFor="password"
                    className="flex mb-2 font-bold text-white"
                  >
                    Password:
                  </label>
                  <input
                    type="password"
                    id="password"
                    className="border border-gray-400 p-2 w-full rounded-lg bg-cyan-100 placeholder-black text-black "
                    value={password}
                    placeholder="Password"
                    onChange={(e) => setPassword(e.target.value)}
                  />
                </div>
              </div>
            </div>
            <div className="home-container flex items-center mx-auto col-md-6">
              <div className="container flex items-center justify-center ">
                <div className="text-white items-center flex flex-col justify-center">
                  <h1 className="mb-3 text-lg">
                    Please take an image of your face
                  </h1>
                  <form className="form">
                    <div className="webcam-container">
                      <div className="webcam-img flex justify-center">
                        {file === "" ? (
                          <Webcam
                            audio={false}
                            height={200}
                            ref={webcamRef}
                            screenshotFormat="image/jpeg"
                            width={220}
                            mirrored="true"
                            videoConstraints={videoConstraints}
                            className="rounded-lg"
                          />
                        ) : (
                          <p className="text-xl font-bold text-white bg-green-500 p-2 rounded-md opacity-60">
                            Image Captured succesfully
                          </p>
                        )}
                      </div>
                      <div className="justify-center flex items-center">
                        {file !== "" ? (
                          <button
                            onClick={(e) => {
                              e.preventDefault();
                              setFile("");
                            }}
                            className="webcam-btn btn m-3 text-white hover:bg-cyan-400 bg-cyan-500 border-cyan-500 p-2 rounded-md"
                          >
                            Retake Image
                          </button>
                        ) : (
                          <button
                            onClick={async (e) => {
                              e.preventDefault();
                              handleFileChange();
                              // You can do something with the file, if needed
                            }}
                            className="webcam-btn btn m-3  text-white hover:bg-cyan-400 bg-cyan-500 border-cyan-500 p-2 rounded-md"
                          >
                            Capture
                          </button>
                        )}
                      </div>
                    </div>
                    {/* <input type="email" placeholder="Email" onChange={(e) => setEmail(e.target.value)} />
                         <input type="text" placeholder="Name" onChange={(e) => setName(e.target.value)} /> */}
                    <div className="flex justify-center items-center mx-auto col-md-6">
                      <ReCAPTCHA sitekey={key} onChange={onChange} />
                    </div>
                  </form>
                </div>
              </div>
            </div>
            <div className="flex justify-center items-center mt-4">
              {captchaIsDone && (
                <button
                  type="submit"
                  className="bg-cyan-500 text-white py-2 px-4 rounded hover:bg-cyan-400 "
                  onClick={handleSubmit}
                >
                  Sign up
                </button>
              )}
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default Signup;
