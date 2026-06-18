import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import SlidesPresentation from "./components/SlidesPresentation";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Navigate to="/slide-1" replace />} />
        <Route path="/:slideNumber" element={<SlidesPresentation />} />
        <Route path="*" element={<Navigate to="/slide-1" replace />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
