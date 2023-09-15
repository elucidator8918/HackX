import React, { useState } from "react";

const Doc = () => {
  const [selectedFile, setSelectedFile] = useState(null);

  const handleFileChange = (event) => {
    setSelectedFile(event.target.files[0]);
  };

  const handleUpload = () => {
    if (selectedFile) {
      const formData = new FormData();
      formData.append("file", selectedFile);
      formData.append("lang", "en");
      fetch("https://example.com/upload-endpoint", {
        method: "POST",
        headers: {
          token: localStorage.getItem("access_token"), // or your desired language code
        },
        body: formData,
      })
        .then((response) => response.json())
        .then((data) => {
          console.log("Image uploaded successfully:", data);
        })
        .catch((error) => {
          console.error("Error uploading image:", error);
        });
    }
  };

  return (
    <div>
      <input type="file" onChange={handleFileChange} />
      <button onClick={handleUpload}>Upload Image</button>
    </div>
  );
};

export default Doc;
