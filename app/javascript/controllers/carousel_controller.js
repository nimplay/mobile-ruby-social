import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["slide"];
  index = 0;

  next() {
    if (this.index < this.slideTargets.length - 2) {
      this.index += 2;
    }
    this.updateView();
  }

  prev() {
    if (this.index > 0) {
      this.index -= 2;
    }
    this.updateView();
  }

  updateView() {
    this.slideTargets.forEach((slide, i) => {
      slide.classList.toggle("hidden", i < this.index || i >= this.index + 2);
    });
  }
}
