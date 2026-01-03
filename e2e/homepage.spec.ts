import { test, expect } from "@playwright/test";

test.describe("Homepage", () => {
  test("should load and display main content", async ({ page }) => {
    await page.goto("/");

    // Check that the page loaded
    await expect(page).toHaveTitle(/Nathan Hadzariga/);

    // Check hero heading
    const heading = page.getByRole("heading", {
      name: /nathan hadzariga/i,
      level: 1,
    });
    await expect(heading).toBeVisible();

    // Check job title
    await expect(
      page.getByText("Staff Software Engineer at Experian")
    ).toBeVisible();

    // Check description
    await expect(page.getByText(/building scalable systems/i)).toBeVisible();

    // Check "coming soon" badge
    await expect(page.getByText(/portfolio coming soon/i)).toBeVisible();
  });

  test("should have navigation links", async ({ page }) => {
    await page.goto("/");

    // Check that all nav links exist
    const homeLink = page.getByRole("link", { name: /^home$/i });
    const portfolioLink = page.getByRole("link", { name: /^portfolio$/i });
    const blogLink = page.getByRole("link", { name: /^blog$/i });
    const aboutLink = page.getByRole("link", { name: /^about$/i });
    const pocsLink = page.getByRole("link", { name: /^pocs$/i });

    await expect(homeLink).toBeVisible();
    await expect(portfolioLink).toBeVisible();
    await expect(blogLink).toBeVisible();
    await expect(aboutLink).toBeVisible();
    await expect(pocsLink).toBeVisible();
  });

  test("should have CTA buttons", async ({ page }) => {
    await page.goto("/");

    // Check View Portfolio button
    const viewPortfolioBtn = page.getByRole("link", {
      name: /view portfolio/i,
    });
    await expect(viewPortfolioBtn).toBeVisible();
    await expect(viewPortfolioBtn).toHaveAttribute("href", "/portfolio");

    // Check Read Blog button
    const readBlogBtn = page.getByRole("link", { name: /read blog/i });
    await expect(readBlogBtn).toBeVisible();
    await expect(readBlogBtn).toHaveAttribute("href", "/blog");
  });

  test("should have footer with social links", async ({ page }) => {
    await page.goto("/");

    // Check footer exists
    const footer = page.locator("footer");
    await expect(footer).toBeVisible();

    // Check copyright
    await expect(footer.getByText(/Nathan Hadzariga/)).toBeVisible();
    await expect(footer.getByText(/All rights reserved/i)).toBeVisible();

    // Check social links exist (even if placeholder URLs)
    await expect(footer.getByRole("link", { name: /linkedin/i })).toBeVisible();
    await expect(footer.getByRole("link", { name: /github/i })).toBeVisible();
    await expect(footer.getByRole("link", { name: /email/i })).toBeVisible();
  });

  test("should be responsive on mobile", async ({ page }) => {
    // Set mobile viewport
    await page.setViewportSize({ width: 375, height: 667 });
    await page.goto("/");

    // Check content is still visible
    await expect(
      page.getByRole("heading", { name: /nathan hadzariga/i })
    ).toBeVisible();

    // Check mobile menu button exists
    const mobileMenuBtn = page.getByRole("button", { name: /toggle menu/i });
    await expect(mobileMenuBtn).toBeVisible();
  });
});
