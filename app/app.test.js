import request from "supertest";
import app from "./app.js";

describe("Test the frontend app", () => {
  test("Get / should render the home page", async () => {
    const response = await request(app).get("/");
    expect(response.statusCode).toBe(200);
    expect(response.text).toContain("Vervium CloudAI");
    expect(response.text).toContain("Synergy");
    expect(response.text).toContain("95.4%");
  });
});
