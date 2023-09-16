import React, { useState } from "react";
import Navbar from "../components/Navbar";

const Doc = () => {
  const [selectedFile, setSelectedFile] = useState(null);
  const [ocrText, setOcrText] = useState(""); // Added state for OCR text

  const handleFileChange = (event) => {
    setSelectedFile(event.target.files[0]);
  };

  const handleUpload = () => {
    if (selectedFile) {
      const formData = new FormData();
      formData.append("file", selectedFile);
      formData.append("lang", "en");
      fetch("https://541a-34-82-10-214.ngrok-free.app/ocr/", {
        method: "POST",
        headers: {
          token: localStorage.getItem("access_token"), // or your desired language code
        },
        body: formData,
      })
        .then((response) => response.json())
        .then((data) => {
          console.log("Image uploaded successfully:", data);
          setOcrText(data.text); // Set OCR text to state
        })
        .catch((error) => {
          console.error("Error uploading image:", error);
        });
    }
  };

  return (
    <div className="py-20 bg-gray-950 h-screen flex flex-col items-center justify-center">
      <Navbar />
      <div className="text-white text-3xl font-bold mb-4 mt-6">
        Upload an Image
      </div>
      <div className="flex items-center">
        <input
          type="file"
          onChange={handleFileChange}
          className="border border-gray-400 p-2 rounded-lg bg-cyan-100 text-black"
        />
        <button
          onClick={handleUpload}
          className="ml-2 bg-cyan-500 text-white py-2 px-4 rounded hover:bg-cyan-400"
        >
          Upload Image
        </button>
      </div>
      {ocrText && (
        <div className="mt-6 text-black bg-cyan-100 p-6 rounded-lg w-5/6">
          <h2 className="text-xl font-bold">OCR Text:</h2>
          <p>{ocrText}</p>
        </div>
      )}
    </div>
  );
};

export default Doc;
