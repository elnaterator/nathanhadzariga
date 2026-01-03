import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen } from "@testing-library/react";
import Header from "./Header";

// Mock Next.js navigation hooks
const mockUsePathname = vi.fn(() => "/");

vi.mock("next/navigation", () => ({
  usePathname: () => mockUsePathname(),
}));

beforeEach(() => {
  mockUsePathname.mockReturnValue("/");
});

describe("Header", () => {
  it("renders the site name", () => {
    render(<Header />);
    expect(screen.getByText("Nathan Hadzariga")).toBeInTheDocument();
  });

  it("renders all navigation items", () => {
    render(<Header />);

    expect(screen.getByText("Home")).toBeInTheDocument();
    expect(screen.getByText("Portfolio")).toBeInTheDocument();
    expect(screen.getByText("Blog")).toBeInTheDocument();
    expect(screen.getByText("POCs")).toBeInTheDocument();
    expect(screen.getByText("About")).toBeInTheDocument();
  });

  it("has correct navigation links", () => {
    render(<Header />);

    const homeLink = screen.getByRole("link", { name: /home/i });
    expect(homeLink).toHaveAttribute("href", "/");

    const portfolioLink = screen.getByRole("link", { name: /portfolio/i });
    expect(portfolioLink).toHaveAttribute("href", "/portfolio");

    const blogLink = screen.getByRole("link", { name: /blog/i });
    expect(blogLink).toHaveAttribute("href", "/blog");
  });

  it("renders mobile menu button", () => {
    render(<Header />);
    const menuButton = screen.getByLabelText("Toggle menu");
    expect(menuButton).toBeInTheDocument();
  });

  it("highlights active navigation item", () => {
    mockUsePathname.mockReturnValue("/portfolio");

    render(<Header />);

    const portfolioLink = screen.getByRole("link", { name: /portfolio/i });
    expect(portfolioLink).toHaveClass("border-blue-500");
  });
});
