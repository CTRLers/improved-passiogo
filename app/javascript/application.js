// Entry point for the build script in your package.json
import "../assets/stylesheets/application.css"
import "./controllers"

// Direct notification and banner tests disabled
// import "./direct_notification_test"
// import "./direct_banner_test"

// Import channels last to avoid blocking other functionality if it fails
try {
    import("./channels").catch(error => {
        console.error("Error loading channels:", error);
    });
} catch (error) {
    console.error("Error importing channels:", error);
}
