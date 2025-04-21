# Changelog for Current Work in Progress

## Features Added
- Implemented real-time bus route tracking system
- Added interactive map component for route visualization
- Integrated notification system with ActionCable
- Added test notification functionality
- Implemented collapsible route cards in the UI

## Technical Changes
1. Frontend Components:
   - Added `bus_routes_component.html.erb` with:
     - Interactive map integration
     - Filterable route list
     - Collapsible route cards
     - Notification test button
     - Real-time route updates

2. Development Environment:
   - Set up Python FastAPI submodule (passiogo-api)
   - Configured Procfile.dev and Procfile.ci for multi-service development
   - Added uvicorn server configuration for Python API

3. Docker Configuration:
   - Updated Dockerfile to include Python environment
   - Added Node.js and MJML support
   - Configured multi-stage build process
   - Set up proper permissions and user access

4. CI/CD Pipeline:
   - Configured GitHub Actions workflow
   - Added security scanning (Brakeman)
   - Set up JavaScript dependency auditing
   - Added Ruby linting (RuboCop)
   - Configured system tests with Chrome

5. Dependencies Added:
   - Tailwind CSS for styling
   - MapBox GL for mapping
   - Various PostCSS plugins
   - Hotwired/Stimulus for JavaScript
   - ActionCable for real-time updates

## Files Modified
- `app/components/routes/bus_routes_component.html.erb`
- `Dockerfile`
- `Procfile.dev`
- `Procfile.ci`
- `.github/workflows/ci.yml`
- Various bin scripts (`run`, `dev`, `ci`, `setup`)
- Configuration files (`.dockerignore`, `.gitignore`)

## Pending Tasks
1. Complete notification system implementation
2. Add proper error handling for API integration
3. Implement route filtering functionality
4. Add user preferences persistence
5. Complete real-time tracking integration

## Testing Status
- Basic system tests configured
- CI pipeline operational
- Manual testing of notification system needed
- Integration tests for Python API pending

## Deployment Notes
- Requires environment variables for:
  - MapBox API keys
  - Database credentials
  - Python API configuration
- Needs volume configuration for persistent storage