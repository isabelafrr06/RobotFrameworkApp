# Flask App with Robot Framework

This is a simple Flask web application with automated tests using Robot Framework.

## Setup

1. Install dependencies:

   ```sh
   pip install -r requirements.txt
   ```

2. Run the Flask app:

   ```sh
   python app.py
   ```

3. Run the tests:
   ```sh
   robot --outputdir tests tests/test_suite.robot
   ```

## Project Structure

- `app.py`: Main application file.
- `templates/base.html`: Base template with Bootstrap.
- `templates/index.html`: Welcome page template.
- `templates/login.html`: Login page template.
- `templates/home.html`: Home page template with product listings.
- `static/styles.css`: Custom styles.
- `tests/test_suite.robot`: Robot Framework test suite.
- `requirements.txt`: List of dependencies.
- `README.md`: Project description.
