import Landing from "./pages/Landing";

import {
  Routes,
  Route,
  useNavigationType,
  useLocation,
} from "react-router-dom";
import { BrowserRouter } from "react-router-dom";
import { Assistant } from "./pages/Assistant";
import Map from "./components/Map";
import Login from "./pages/Login";
import Signup from "./pages/Signup";

function App() {
  return (
    <div className="App">
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Landing />} />
          <Route path="/login" element={<Login />} />
          <Route path="/signup" element={<Signup />} />
          <Route path="/Assistant" element={<Assistant />} />
          <Route path="/Map" element={<Map />} />
        </Routes>
      </BrowserRouter>
    </div>
  );
}

export default App;
