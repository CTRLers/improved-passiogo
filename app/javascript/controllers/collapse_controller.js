import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content"];

  connect() {
    console.log("Collapse controller connected", this.hasContentTarget);
  }

  toggle() {
    console.log("Toggling collapse; contentTarget:", this.contentTarget);
    this.contentTarget.classList.toggle("hidden");
  }
}
