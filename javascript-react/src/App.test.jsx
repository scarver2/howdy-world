// javascript-react/src/App.test.jsx
import { render, screen } from "@testing-library/react";
import App from "./App";

test('renders "Howdy, World!" inside an H1', () => {
    render(<App />);

    // Best practice: query by semantic role + accessible name
    const heading = screen.getByRole("heading", { level: 1, name: "Howdy, World!" });

    expect(heading).toBeInTheDocument();
    expect(heading.tagName).toBe("H1");
});
