import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ['input']
  connect() {
  }
  searchProcess() {
    console.log('detect action', this.inputTarget.value);
  }
}
