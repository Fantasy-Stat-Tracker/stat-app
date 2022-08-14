import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clickable-tr"
export default class extends Controller {
  static targets = [ "clickable-row" ]

  static values = {
    url: String
  }

  follow() {
    debugger
    window.location = this.urlValue
  }
}
