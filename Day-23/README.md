# Forking Repository: sarah/story-blog

This document describes the process for the developer **Jon** to fork and start working with the `sarah/story-blog` repository in Gitea.

---

## Steps

1. **Login to Gitea**
   - Navigate to the Gitea UI (top bar in the environment).
   - Login with:
     - **Username:** `jon`
     - **Password:** `Jon_pass123`

2. **Locate the Repository**
   - After logging in, search for the repository **`sarah/story-blog`** in the Explore section or via the search bar.

3. **Fork the Repository**
   - Open the repository page.
   - Click the **Fork** button on the top-right.
   - Select namespace **jon** and confirm.
   - This creates a fork at **jon/story-blog**.

4. **Verify the Fork**
   - Ensure the repository **jon/story-blog** exists under Jon’s profile.

5. **Clone and Setup Local Copy**
   ```bash
   git clone http://<gitea-server>/jon/story-blog.git
   cd story-blog
   git remote -v

